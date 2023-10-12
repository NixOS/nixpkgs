{ stdenv, buildPackages, lib
, fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
, zlib, gdbm, ncurses, readline, groff, libyaml, libffi, jemalloc, autoreconfHook, bison
, autoconf, libiconv, libobjc, libunwind, Foundation
, buildEnv, bundler, bundix, cargo, rustPlatform, rustc
, makeBinaryWrapper, buildRubyGem, defaultGemConfig, removeReferencesTo
, openssl, openssl_1_1
, linuxPackages, libsystemtap
} @ args:

let
  op = lib.optional;
  ops = lib.optionals;
  opString = lib.optionalString;
  config = import ./config.nix { inherit fetchFromSavannah; };
  rubygems = import ./rubygems { inherit stdenv lib fetchurl; };

  openssl3Gem = fetchFromGitHub {
    owner = "ruby";
    repo = "openssl";
    rev = "v3.0.2";
    hash = "sha256-KhuKRP1JkMJv7CagGRQ0KKGOd5Oh0FP0fbj0VZ4utGo=";
  };

  # Contains the ruby version heuristics
  rubyVersion = import ./ruby-version.nix { inherit lib; };

  generic = { version, sha256, cargoSha256 ? null }: let
    ver = version;
    atLeast30 = lib.versionAtLeast ver.majMin "3.0";
    atLeast31 = lib.versionAtLeast ver.majMin "3.1";
    atLeast32 = lib.versionAtLeast ver.majMin "3.2";
    # https://github.com/ruby/ruby/blob/v3_2_2/yjit.h#L21
    yjitSupported = atLeast32 && (stdenv.hostPlatform.isx86_64 || (!stdenv.hostPlatform.isWindows && stdenv.hostPlatform.isAarch64));
    self = lib.makeOverridable (
      { stdenv, buildPackages, lib
      , fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
      , rubygemsSupport ? true
      , zlib, zlibSupport ? true
      , openssl, openssl_1_1, opensslSupport ? true
      , gdbm, gdbmSupport ? true
      , ncurses, readline, cursesSupport ? true
      , groff, docSupport ? true
      , libyaml, yamlSupport ? true
      , libffi, fiddleSupport ? true
      , jemalloc, jemallocSupport ? false
      , linuxPackages, systemtap ? linuxPackages.systemtap, libsystemtap, dtraceSupport ? false
      # By default, ruby has 3 observed references to stdenv.cc:
      #
      # - If you run:
      #     ruby -e "puts RbConfig::CONFIG['configure_args']"
      # - In:
      #     $out/${passthru.libPath}/${stdenv.hostPlatform.system}/rbconfig.rb
      #   Or (usually):
      #     $(nix-build -A ruby)/lib/ruby/2.6.0/x86_64-linux/rbconfig.rb
      # - In $out/lib/libruby.so and/or $out/lib/libruby.dylib
      , removeReferencesTo, jitSupport ? yjitSupport
      , cargo, rustPlatform, rustc, yjitSupport ? yjitSupported
      , autoreconfHook, bison, autoconf
      , buildEnv, bundler, bundix
      , libiconv, libobjc, libunwind, Foundation
      , makeBinaryWrapper, buildRubyGem, defaultGemConfig
      , baseRuby ? buildPackages.ruby.override {
          docSupport = false;
          rubygemsSupport = false;
        }
      , useBaseRuby ? stdenv.hostPlatform != stdenv.buildPlatform
      }:
      stdenv.mkDerivation rec {
        pname = "ruby";
        inherit version;

        src = fetchurl {
          url = "https://cache.ruby-lang.org/pub/ruby/${ver.majMin}/ruby-${ver}.tar.gz";
          inherit sha256;
        };

        # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
        NROFF = if docSupport then "${groff}/bin/nroff" else null;

        outputs = [ "out" ] ++ lib.optional docSupport "devdoc";

        strictDeps = true;

        nativeBuildInputs = [ autoreconfHook bison ]
          ++ (op docSupport groff)
          ++ (ops (dtraceSupport && stdenv.isLinux) [ systemtap libsystemtap ])
          ++ ops yjitSupport [ rustPlatform.cargoSetupHook cargo rustc ]
          ++ op useBaseRuby baseRuby;
        buildInputs = [ autoconf ]
          ++ (op fiddleSupport libffi)
          ++ (ops cursesSupport [ ncurses readline ])
          ++ (op zlibSupport zlib)
          ++ (op (atLeast30 && opensslSupport) openssl)
          ++ (op (!atLeast30 && opensslSupport) openssl_1_1)
          ++ (op gdbmSupport gdbm)
          ++ (op yamlSupport libyaml)
          # Looks like ruby fails to build on darwin without readline even if curses
          # support is not enabled, so add readline to the build inputs if curses
          # support is disabled (if it's enabled, we already have it) and we're
          # running on darwin
          ++ op (!cursesSupport && stdenv.isDarwin) readline
          ++ ops stdenv.isDarwin [ libiconv libobjc libunwind Foundation ];
        propagatedBuildInputs = op jemallocSupport jemalloc;

        enableParallelBuilding = true;
        # /build/ruby-2.7.7/lib/fileutils.rb:882:in `chmod':
        #   No such file or directory @ apply2files - ...-ruby-2.7.7-devdoc/share/ri/2.7.0/system/ARGF/inspect-i.ri (Errno::ENOENT)
        # make: *** [uncommon.mk:373: do-install-all] Error 1
        enableParallelInstalling = false;

        patches = op (lib.versionOlder ver.majMin "3.1") ./do-not-regenerate-revision.h.patch
          ++ op (atLeast30 && useBaseRuby) (
            if atLeast32 then ./do-not-update-gems-baseruby-3.2.patch
            else ./do-not-update-gems-baseruby.patch
          )
          ++ ops (ver.majMin == "3.0") [
            # Ruby 3.0 adds `-fdeclspec` to $CC instead of $CFLAGS. Fixed in later versions.
            (fetchpatch {
              url = "https://github.com/ruby/ruby/commit/0acc05caf7518cd0d63ab02bfa036455add02346.patch";
              sha256 = "sha256-43hI9L6bXfeujgmgKFVmiWhg7OXvshPCCtQ4TxqK1zk=";
            })
         ]
          ++ ops (!atLeast30 && rubygemsSupport) [
            # We upgrade rubygems to a version that isn't compatible with the
            # ruby 2.7 installer. Backport the upstream fix.
            ./rbinstall-new-rubygems-compat.patch

            # Ruby prior to 3.0 has a bug the installer (tools/rbinstall.rb) but
            # the resulting error was swallowed. Newer rubygems no longer swallows
            # this error. We upgrade rubygems when rubygemsSupport is enabled, so
            # we have to fix this bug to prevent the install step from failing.
            # See https://github.com/ruby/ruby/pull/2930
            (fetchpatch {
              url = "https://github.com/ruby/ruby/commit/261d8dd20afd26feb05f00a560abd99227269c1c.patch";
              sha256 = "0wrii25cxcz2v8bgkrf7ibcanjlxwclzhayin578bf0qydxdm9qy";
            })
          ]
          ++ ops atLeast31 [
            # When using a baseruby, ruby always sets "libdir" to the build
            # directory, which nix rejects due to a reference in to /build/ in
            # the final product. Removing this reference doesn't seem to break
            # anything and fixes cross compliation.
            ./dont-refer-to-build-dir.patch
          ];

        cargoRoot = opString yjitSupport "yjit";

        cargoDeps = if yjitSupport then rustPlatform.fetchCargoTarball {
          inherit src;
          sourceRoot = "${pname}-${version}/${cargoRoot}";
          sha256 = cargoSha256;
        } else null;

        postUnpack = opString rubygemsSupport ''
          rm -rf $sourceRoot/{lib,test}/rubygems*
          cp -r ${rubygems}/lib/rubygems* $sourceRoot/lib
          cp -r ${rubygems}/test/rubygems $sourceRoot/test
        '' + opString (ver.majMin == "3.0" && opensslSupport) ''
          # Replace the Gem by a OpenSSL3-compatible one.
          echo "Hotpatching the OpenSSL gem with a 3.x series for OpenSSL 3 support..."
          cp -vr ${openssl3Gem}/ext/openssl $sourceRoot/ext/
          cp -vr ${openssl3Gem}/lib/ $sourceRoot/ext/openssl/
          cp -vr ${openssl3Gem}/{History.md,openssl.gemspec} $sourceRoot/ext/openssl/
        '';

        postPatch = ''
          sed -i configure.ac -e '/config.guess/d'
          cp --remove-destination ${config}/config.guess tool/
          cp --remove-destination ${config}/config.sub tool/
        '' + opString (!atLeast30) ''
          # Make the build reproducible for ruby <= 2.7
          # See https://github.com/ruby/io-console/commit/679a941d05d869f5e575730f6581c027203b7b26#diff-d8422f096931c58d4463e2489f62a228b0f24f0492950ba88c8c89a0d741cfe6
          sed -i ext/io/console/io-console.gemspec -e '/s\.date/d'
        '';

        configureFlags = [
          (lib.enableFeature (!stdenv.hostPlatform.isStatic) "shared")
          (lib.enableFeature true "pthread")
          (lib.withFeatureAs true "soname" "ruby-${version}")
          (lib.withFeatureAs useBaseRuby "baseruby" "${baseRuby}/bin/ruby")
          (lib.enableFeature dtraceSupport "dtrace")
          (lib.enableFeature jitSupport "jit-support")
          (lib.enableFeature yjitSupport "yjit")
          (lib.enableFeature docSupport "install-doc")
          (lib.withFeature jemallocSupport "jemalloc")
          (lib.withFeatureAs docSupport "ridir" "${placeholder "devdoc"}/share/ri")
          # ruby enables -O3 for gcc, however our compiler hardening wrapper
          # overrides that by enabling `-O2` which is the minimum optimization
          # needed for `_FORTIFY_SOURCE`.
        ] ++ lib.optional stdenv.cc.isGNU "CFLAGS=-O3" ++ [
        ] ++ ops stdenv.isDarwin [
          # on darwin, we have /usr/include/tk.h -- so the configure script detects
          # that tk is installed
          "--with-out-ext=tk"
          # on yosemite, "generating encdb.h" will hang for a very long time without this flag
          "--with-setjmp-type=setjmp"
        ];

        preConfigure = opString docSupport ''
          # rdoc creates XDG_DATA_DIR (defaulting to $HOME/.local/share) even if
          # it's not going to be used.
          export HOME=$TMPDIR
        '';

        # fails with "16993 tests, 2229489 assertions, 105 failures, 14 errors, 89 skips"
        # mostly TZ- and patch-related tests
        # TZ- failures are caused by nix sandboxing, I didn't investigate others
        doCheck = false;

        preInstall = ''
          # Ruby installs gems here itself now.
          mkdir -pv "$out/${passthru.gemPath}"
          export GEM_HOME="$out/${passthru.gemPath}"
        '';

        installFlags = lib.optional docSupport "install-doc";
        # Bundler tries to create this directory
        postInstall = ''
          rbConfig=$(find $out/lib/ruby -name rbconfig.rb)
          # Remove references to the build environment from the closure
          sed -i '/^  CONFIG\["\(BASERUBY\|SHELL\|GREP\|EGREP\|MKDIR_P\|MAKEDIRS\|INSTALL\)"\]/d' $rbConfig
          # Remove unnecessary groff reference from runtime closure, since it's big
          sed -i '/NROFF/d' $rbConfig
          ${
            lib.optionalString (!jitSupport) ''
              # Get rid of the CC runtime dependency
              ${removeReferencesTo}/bin/remove-references-to \
                -t ${stdenv.cc} \
                $out/lib/libruby*
              ${removeReferencesTo}/bin/remove-references-to \
                -t ${stdenv.cc} \
                $rbConfig
              sed -i '/CC_VERSION_MESSAGE/d' $rbConfig
            ''
          }

          # Allow to override compiler. This is important for cross compiling as
          # we need to set a compiler that is different from the build one.
          sed -i 's/CONFIG\["CC"\] = "\(.*\)"/CONFIG["CC"] = if ENV["CC"].nil? || ENV["CC"].empty? then "\1" else ENV["CC"] end/'  "$rbConfig"

          # Remove unnecessary external intermediate files created by gems
          extMakefiles=$(find $out/${passthru.gemPath} -name Makefile)
          for makefile in $extMakefiles; do
            make -C "$(dirname "$makefile")" distclean
          done
          find "$out/${passthru.gemPath}" \( -name gem_make.out -o -name mkmf.log \) -delete
          # Bundler tries to create this directory
          mkdir -p $out/nix-support
          cat > $out/nix-support/setup-hook <<EOF
          addGemPath() {
            addToSearchPath GEM_PATH \$1/${passthru.gemPath}
          }
          addRubyLibPath() {
            addToSearchPath RUBYLIB \$1/lib/ruby/site_ruby
            addToSearchPath RUBYLIB \$1/lib/ruby/site_ruby/${ver.libDir}
            addToSearchPath RUBYLIB \$1/lib/ruby/site_ruby/${ver.libDir}/${stdenv.hostPlatform.system}
          }

          addEnvHooks "$hostOffset" addGemPath
          addEnvHooks "$hostOffset" addRubyLibPath
          EOF
        '' + opString docSupport ''
          # Prevent the docs from being included in the closure
          sed -i "s|\$(DESTDIR)$devdoc|\$(datarootdir)/\$(RI_BASE_NAME)|" $rbConfig
          sed -i "s|'--with-ridir=$devdoc/share/ri'||" $rbConfig

          # Add rbconfig shim so ri can find docs
          mkdir -p $devdoc/lib/ruby/site_ruby
          cp ${./rbconfig.rb} $devdoc/lib/ruby/site_ruby/rbconfig.rb
        '' + opString useBaseRuby ''
          # Prevent the baseruby from being included in the closure.
          ${removeReferencesTo}/bin/remove-references-to \
            -t ${baseRuby} \
            $rbConfig $out/lib/libruby*
        '';

        installCheckPhase = ''
          overriden_cc=$(CC=foo $out/bin/ruby -rrbconfig -e 'puts RbConfig::CONFIG["CC"]')
          if [[ "$overriden_cc" != "foo" ]]; then
             echo "CC cannot be overwritten: $overriden_cc != foo" >&2
             false
          fi

          fallback_cc=$(unset CC; $out/bin/ruby -rrbconfig -e 'puts RbConfig::CONFIG["CC"]')
          if [[ "$fallback_cc" != "$CC" ]]; then
             echo "CC='$fallback_cc' should be '$CC' by default" >&2
             false
          fi
        '';
        doInstallCheck = true;

        disallowedRequisites = op (!jitSupport) stdenv.cc.cc
          ++ op useBaseRuby baseRuby;

        meta = with lib; {
          description = "An object-oriented language for quick and easy programming";
          homepage    = "https://www.ruby-lang.org/";
          license     = licenses.ruby;
          maintainers = with maintainers; [ vrthra manveru marsam ];
          platforms   = platforms.all;
          knownVulnerabilities = op (lib.versionOlder ver.majMin "3.0") "This Ruby release has reached its end of life. See https://www.ruby-lang.org/en/downloads/branches/.";
        };

        passthru = rec {
          version = ver;
          rubyEngine = "ruby";
          libPath = "lib/${rubyEngine}/${ver.libDir}";
          gemPath = "lib/${rubyEngine}/gems/${ver.libDir}";
          devEnv = import ./dev.nix {
            inherit buildEnv bundler bundix;
            ruby = self;
          };

          inherit rubygems;
          inherit (import ../../ruby-modules/with-packages {
            inherit lib stdenv makeBinaryWrapper buildRubyGem buildEnv;
            gemConfig = defaultGemConfig;
            ruby = self;
          }) withPackages buildGems gems;

        } // lib.optionalAttrs useBaseRuby {
          inherit baseRuby;
        };
      }
    ) args; in self;

in {
  mkRubyVersion = rubyVersion;
  mkRuby = generic;

  ruby_2_7 = generic {
    version = rubyVersion "2" "7" "8" "";
    sha256 = "sha256-wtq2PLyPKgVSYQitQZ76Y6Z+1AdNu8+fwrHKZky0W6A=";
  };

  ruby_3_0 = generic {
    version = rubyVersion "3" "0" "6" "";
    sha256 = "sha256-bmy9SQAw15EMD/IO3vq0KU380QRvD49H94tZeYesaD4=";
  };

  ruby_3_1 = generic {
    version = rubyVersion "3" "1" "4" "";
    sha256 = "sha256-o9VYeaDfqx1xQf3xDSKgfb+OXNxEFdob3gYSfVzDx7Y=";
  };

  ruby_3_2 = generic {
    version = rubyVersion "3" "2" "2" "";
    sha256 = "sha256-lsV1WIcaZ0jeW8nydOk/S1qtBs2PN776Do2U57ikI7w=";
    cargoSha256 = "sha256-6du7RJo0DH+eYMOoh3L31F3aqfR5+iG1iKauSV1uNcQ=";
  };

  ruby_3_3 = generic {
    version = rubyVersion "3" "3" "0" "preview2";
    sha256 = "sha256-MM6LD+EbN7WsCI9aV2V0S5NerEW7ianjgXMVMxRPWZE=";
    cargoSha256 = "sha256-GeelTMRFIyvz1QS2L+Q3KAnyQy7jc0ejhx3TdEFVEbk=";
  };

}
