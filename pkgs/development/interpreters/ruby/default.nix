{ stdenv, buildPackages, lib
, fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
, zlib, openssl, gdbm, ncurses, readline, groff, libyaml, libffi, jemalloc, autoreconfHook, bison
, autoconf, libiconv, libobjc, libunwind, Foundation
, buildEnv, bundler, bundix
, makeWrapper, buildRubyGem, defaultGemConfig, removeReferencesTo
} @ args:

let
  op = lib.optional;
  ops = lib.optionals;
  opString = lib.optionalString;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  config = import ./config.nix { inherit fetchFromSavannah; };
  rubygems = import ./rubygems { inherit stdenv lib fetchurl; };

  # Contains the ruby version heuristics
  rubyVersion = import ./ruby-version.nix { inherit lib; };

  generic = { version, sha256 }: let
    ver = version;
    tag = ver.gitTag;
    atLeast30 = lib.versionAtLeast ver.majMin "3.0";
    self = lib.makeOverridable (
      { stdenv, buildPackages, lib
      , fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
      , useRailsExpress ? true
      , rubygemsSupport ? true
      , zlib, zlibSupport ? true
      , openssl, opensslSupport ? true
      , gdbm, gdbmSupport ? true
      , ncurses, readline, cursesSupport ? true
      , groff, docSupport ? true
      , libyaml, yamlSupport ? true
      , libffi, fiddleSupport ? true
      , jemalloc, jemallocSupport ? false
      # By default, ruby has 3 observed references to stdenv.cc:
      #
      # - If you run:
      #     ruby -e "puts RbConfig::CONFIG['configure_args']"
      # - In:
      #     $out/${passthru.libPath}/${stdenv.hostPlatform.system}/rbconfig.rb
      #   Or (usually):
      #     $(nix-build -A ruby)/lib/ruby/2.6.0/x86_64-linux/rbconfig.rb
      # - In $out/lib/libruby.so and/or $out/lib/libruby.dylib
      , removeReferencesTo, jitSupport ? false
      , autoreconfHook, bison, autoconf
      , buildEnv, bundler, bundix
      , libiconv, libobjc, libunwind, Foundation
      , makeWrapper, buildRubyGem, defaultGemConfig
      , baseRuby ? buildPackages.ruby.override {
          useRailsExpress = false;
          docSupport = false;
          rubygemsSupport = false;
        }
      , useBaseRuby ? stdenv.hostPlatform != stdenv.buildPlatform || useRailsExpress
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

        nativeBuildInputs = [ autoreconfHook bison ]
          ++ (op docSupport groff)
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

        patches =
          (import ./patchsets.nix {
            inherit patchSet useRailsExpress ops fetchpatch;
            patchLevel = ver.patchLevel;
          }).${ver.majMinTiny}
          ++ op (lib.versionOlder ver.majMin "3.1") ./do-not-regenerate-revision.h.patch
          ++ op (atLeast30 && useBaseRuby) ./do-not-update-gems-baseruby.patch
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
          ];

        postUnpack = opString rubygemsSupport ''
          rm -rf $sourceRoot/{lib,test}/rubygems*
          cp -r ${rubygems}/lib/rubygems* $sourceRoot/lib
          cp -r ${rubygems}/test/rubygems $sourceRoot/test
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
          (lib.enableFeature jitSupport "jit-support")
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
          # Remove unnecessary external intermediate files created by gems
          extMakefiles=$(find $out/lib/ruby/gems -name Makefile)
          for makefile in $extMakefiles; do
            make -C "$(dirname "$makefile")" distclean
          done
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

        disallowedRequisites = op (!jitSupport) stdenv.cc.cc
          ++ op useBaseRuby baseRuby;

        meta = with lib; {
          description = "The Ruby language";
          homepage    = "http://www.ruby-lang.org/en/";
          license     = licenses.ruby;
          maintainers = with maintainers; [ vrthra manveru marsam ];
          platforms   = platforms.all;
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

          inherit (import ../../ruby-modules/with-packages {
            inherit lib stdenv makeWrapper buildRubyGem buildEnv;
            gemConfig = defaultGemConfig;
            ruby = self;
          }) withPackages gems;

          # deprecated 2016-09-21
          majorVersion = ver.major;
          minorVersion = ver.minor;
          teenyVersion = ver.tiny;
          patchLevel = ver.patchLevel;
        } // lib.optionalAttrs useBaseRuby {
          inherit baseRuby;
        };
      }
    ) args; in self;

in {
  mkRubyVersion = rubyVersion;
  mkRuby = generic;

  ruby_2_7 = generic {
    version = rubyVersion "2" "7" "6" "";
    sha256 = "042xrdk7hsv4072bayz3f8ffqh61i8zlhvck10nfshllq063n877";
  };

  ruby_3_0 = generic {
    version = rubyVersion "3" "0" "4" "";
    sha256 = "0avj4g3s2839b2y4m6pk8kid74r8nj7k0qm2rsdcwjzhg8h7rd3h";
  };

  ruby_3_1 = generic {
    version = rubyVersion "3" "1" "2" "";
    sha256 = "0gm84ipk6mrfw94852w5h7xxk2lqrxjbnlwb88svf0lz70933131";
  };
}
