{ stdenv, buildPackages, lib
, fetchurl, fetchpatch, fetchFromSavannah
, zlib, gdbm, ncurses, readline, groff, libyaml, libffi, jemalloc, autoreconfHook, bison
, autoconf, libiconv, libobjc, libunwind, Foundation
, buildEnv, bundler, bundix, cargo, rustPlatform, rustc
, makeBinaryWrapper, buildRubyGem, defaultGemConfig, removeReferencesTo
, openssl
, linuxPackages, libsystemtap
} @ args:

let
  op = lib.optional;
  ops = lib.optionals;
  opString = lib.optionalString;
  config = import ./config.nix { inherit fetchFromSavannah; };
  rubygems = import ./rubygems { inherit stdenv lib fetchurl; };

  # Contains the ruby version heuristics
  rubyVersion = import ./ruby-version.nix { inherit lib; };

  generic = { version, hash, cargoHash ? null }: let
    ver = version;
    atLeast31 = lib.versionAtLeast ver.majMin "3.1";
    atLeast32 = lib.versionAtLeast ver.majMin "3.2";
    # https://github.com/ruby/ruby/blob/v3_2_2/yjit.h#L21
    yjitSupported = atLeast32 && (stdenv.hostPlatform.isx86_64 || (!stdenv.hostPlatform.isWindows && stdenv.hostPlatform.isAarch64));
    rubyDrv = lib.makeOverridable (
      { stdenv, buildPackages, lib
      , fetchurl, fetchpatch, fetchFromSavannah
      , rubygemsSupport ? true
      , zlib, zlibSupport ? true
      , openssl, opensslSupport ? true
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
      stdenv.mkDerivation ( finalAttrs: {
        pname = "ruby";
        inherit version;

        src = fetchurl {
          url = "https://cache.ruby-lang.org/pub/ruby/${ver.majMin}/ruby-${ver}.tar.gz";
          inherit hash;
        };

        # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
        NROFF = if docSupport then "${groff}/bin/nroff" else null;

        outputs = [ "out" ] ++ lib.optional docSupport "devdoc";

        strictDeps = true;

        nativeBuildInputs = [ autoreconfHook bison removeReferencesTo ]
          ++ (op docSupport groff)
          ++ (ops (dtraceSupport && stdenv.isLinux) [ systemtap libsystemtap ])
          ++ ops yjitSupport [ rustPlatform.cargoSetupHook cargo rustc ]
          ++ op useBaseRuby baseRuby;
        buildInputs = [ autoconf ]
          ++ (op fiddleSupport libffi)
          ++ (ops cursesSupport [ ncurses readline ])
          ++ (op zlibSupport zlib)
          ++ (op opensslSupport openssl)
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
          ++ op useBaseRuby (
            if atLeast32 then ./do-not-update-gems-baseruby-3.2.patch
            else ./do-not-update-gems-baseruby.patch
          )
          ++ ops (ver.majMin == "3.0") [
            # Ruby 3.0 adds `-fdeclspec` to $CC instead of $CFLAGS. Fixed in later versions.
            (fetchpatch {
              url = "https://github.com/ruby/ruby/commit/0acc05caf7518cd0d63ab02bfa036455add02346.patch";
              hash = "sha256-43hI9L6bXfeujgmgKFVmiWhg7OXvshPCCtQ4TxqK1zk=";
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
          inherit (finalAttrs) src;
          sourceRoot = "${finalAttrs.pname}-${version}/${finalAttrs.cargoRoot}";
          hash = assert cargoHash != null; cargoHash;
        } else null;

        postUnpack = opString rubygemsSupport ''
          rm -rf $sourceRoot/{lib,test}/rubygems*
          cp -r ${rubygems}/lib/rubygems* $sourceRoot/lib
        '';

        postPatch = ''
          sed -i configure.ac -e '/config.guess/d'
          cp --remove-destination ${config}/config.guess tool/
          cp --remove-destination ${config}/config.sub tool/
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
        ] ++ ops stdenv.hostPlatform.isFreeBSD [
          "rb_cv_gnu_qsort_r=no"
          "rb_cv_bsd_qsort_r=yes"
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
          mkdir -pv "$out/${finalAttrs.passthru.gemPath}"
          export GEM_HOME="$out/${finalAttrs.passthru.gemPath}"
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
              remove-references-to \
                -t ${stdenv.cc} \
                $out/lib/libruby*
              remove-references-to \
                -t ${stdenv.cc} \
                $rbConfig
              sed -i '/CC_VERSION_MESSAGE/d' $rbConfig
            ''
          }

          # Allow to override compiler. This is important for cross compiling as
          # we need to set a compiler that is different from the build one.
          sed -i "$rbConfig" \
            -e 's/CONFIG\["CC"\] = "\(.*\)"/CONFIG["CC"] = if ENV["CC"].nil? || ENV["CC"].empty? then "\1" else ENV["CC"] end/' \
            -e 's/CONFIG\["CXX"\] = "\(.*\)"/CONFIG["CXX"] = if ENV["CXX"].nil? || ENV["CXX"].empty? then "\1" else ENV["CXX"] end/'

          # Remove unnecessary external intermediate files created by gems
          extMakefiles=$(find $out/${finalAttrs.passthru.gemPath} -name Makefile)
          for makefile in $extMakefiles; do
            make -C "$(dirname "$makefile")" distclean
          done
          find "$out/${finalAttrs.passthru.gemPath}" \( -name gem_make.out -o -name mkmf.log \) -delete
          # Bundler tries to create this directory
          mkdir -p $out/nix-support
          cat > $out/nix-support/setup-hook <<EOF
          addGemPath() {
            addToSearchPath GEM_PATH \$1/${finalAttrs.passthru.gemPath}
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
          remove-references-to \
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

        disallowedRequisites = op (!jitSupport) stdenv.cc
          ++ op useBaseRuby baseRuby;

        meta = with lib; {
          description = "Object-oriented language for quick and easy programming";
          homepage    = "https://www.ruby-lang.org/";
          license     = licenses.ruby;
          maintainers = with maintainers; [ vrthra manveru ];
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
            ruby = finalAttrs.finalPackage;
          };

          inherit rubygems;
          inherit (import ../../ruby-modules/with-packages {
            inherit lib stdenv makeBinaryWrapper buildRubyGem buildEnv;
            gemConfig = defaultGemConfig;
            ruby = finalAttrs.finalPackage;
          }) withPackages buildGems gems;
        } // lib.optionalAttrs useBaseRuby {
          inherit baseRuby;
        };
      } )
    ) args; in rubyDrv;

in {
  mkRubyVersion = rubyVersion;
  mkRuby = generic;

  ruby_3_1 = generic {
    version = rubyVersion "3" "1" "5" "";
    hash = "sha256-NoXFHu7hNSwx6gOXBtcZdvU9AKttdzEt5qoauvXNosU=";
  };

  ruby_3_2 = generic {
    version = rubyVersion "3" "2" "4" "";
    hash = "sha256-xys8XDBILcoYsPhoyQdfP0fYFo6vYm1OaCzltZyFhpI=";
    cargoHash = "sha256-6du7RJo0DH+eYMOoh3L31F3aqfR5+iG1iKauSV1uNcQ=";
  };

  ruby_3_3 = generic {
    version = rubyVersion "3" "3" "2" "";
    hash = "sha256-O+HRAOvyoM5gws2NIs2dtNZLPgShlDvixP97Ug8ry1s=";
    cargoHash = "sha256-GeelTMRFIyvz1QS2L+Q3KAnyQy7jc0ejhx3TdEFVEbk=";
  };

}
