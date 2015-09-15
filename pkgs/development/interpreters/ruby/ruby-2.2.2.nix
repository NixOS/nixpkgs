{ stdenv, lib, fetchurl, fetchFromSavannah, fetchFromGitHub
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? true
, groff, docSupport ? false
, libyaml, yamlSupport ? true
, libffi, fiddleSupport ? true
, ruby_2_2_2, autoreconfHook, bison, useRailsExpress ? true
, libiconv, libobjc, libunwind
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  config = import ./config.nix { inherit fetchFromSavannah; };
  baseruby = ruby_2_2_2.override { useRailsExpress = false; };
in

stdenv.mkDerivation rec {
  version = with passthru; "${majorVersion}.${minorVersion}.${teenyVersion}-p${patchLevel}";

  name = "ruby-${version}";

  src = if useRailsExpress then fetchFromGitHub {
    owner  = "ruby";
    repo   = "ruby";
    rev    = "v2_2_2";
    sha256 = "08mw1ql2ghy483cp8xzzm78q17simn4l6phgm2gah7kjh9y3vbrn";
  } else fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz";
    sha256 = "0i4v7l8pnam0by2cza12zldlhrffqchwb2m9shlnp7j2gqqhzz2z";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  buildInputs = ops useRailsExpress [ autoreconfHook bison ]
    ++ (op fiddleSupport libffi)
    ++ (ops cursesSupport [ ncurses readline ])
    ++ (op docSupport groff)
    ++ (op zlibSupport zlib)
    ++ (op opensslSupport openssl)
    ++ (op gdbmSupport gdbm)
    ++ (op yamlSupport libyaml)
    # Looks like ruby fails to build on darwin without readline even if curses
    # support is not enabled, so add readline to the build inputs if curses
    # support is disabled (if it's enabled, we already have it) and we're
    # running on darwin
    ++ (op (!cursesSupport && stdenv.isDarwin) readline)
    ++ (ops stdenv.isDarwin [ libiconv libobjc libunwind ]);

  enableParallelBuilding = true;

  patches = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.2.2/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.2.2/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.2.2/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.2.2/railsexpress/04-backported-bugfixes-222.patch"
  ];

  postPatch = ops useRailsExpress ''
    sed -i configure.in -e '/config.guess/d'
    cp ${config}/config.guess tool/
    cp ${config}/config.sub tool/
  '';

  configureFlags = ["--enable-shared" ]
    ++ op useRailsExpress "--with-baseruby=${baseruby}/bin/ruby"
    # on darwin, we have /usr/include/tk.h -- so the configure script detects
    # that tk is installed
    ++ ( if stdenv.isDarwin then [ "--with-out-ext=tk " ] else [ ]);

  installFlags = stdenv.lib.optionalString docSupport "install-doc";
  # Bundler tries to create this directory
  postInstall = ''
    # Bundler tries to create this directory
    mkdir -pv $out/${passthru.gemPath}
    mkdir -p $out/nix-support
    cat > $out/nix-support/setup-hook <<EOF
    addGemPath() {
      addToSearchPath GEM_PATH \$1/${passthru.gemPath}
    }

    envHooks+=(addGemPath)
    EOF
  '' + lib.optionalString useRailsExpress ''
    rbConfig=$(find $out/lib/ruby -name rbconfig.rb)

    # Prevent the baseruby from being included in the closure.
    sed -i '/^  CONFIG\["BASERUBY"\]/d' $rbConfig
    sed -i "s|'--with-baseruby=${baseruby}/bin/ruby'||" $rbConfig
  '';

  meta = {
    license = stdenv.lib.licenses.ruby;
    homepage = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
    platforms = stdenv.lib.platforms.all;
  };

  passthru = rec {
    majorVersion = "2";
    minorVersion = "2";
    teenyVersion = "2";
    patchLevel = "0";
    rubyEngine = "ruby";
    libPath = "lib/${rubyEngine}/${majorVersion}.${minorVersion}.${teenyVersion}";
    gemPath = "lib/${rubyEngine}/gems/${majorVersion}.${minorVersion}.${teenyVersion}";
  };
}
