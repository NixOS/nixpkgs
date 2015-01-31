{ stdenv, lib, fetchurl, fetchgit, fetchFromGitHub
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? true
, groff, docSupport ? false
, libyaml, yamlSupport ? true
, libffi, fiddleSupport ? true
, ruby_2_2_0, autoreconfHook, bison, useRailsExpress ? true
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  config = import ./config.nix fetchgit;
  baseruby = ruby_2_2_0.override { useRailsExpress = false; };
in

stdenv.mkDerivation rec {
  version = with passthru; "${majorVersion}.${minorVersion}.${teenyVersion}-p${patchLevel}";

  name = "ruby-${version}";

  src = if useRailsExpress then fetchFromGitHub {
    owner  = "ruby";
    repo   = "ruby";
    rev    = "v2_2_0";
    sha256 = "1w7rr2nq1bbw6aiagddzlrr3rl95kk33x4pv6570nm072g55ybpi";
  } else fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz";
    sha256 = "1z2092fbpc2qkv1j3yj7jdz7qwvqpxqpmcnkphpjcpgvmfaf6wbn";
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
    ++ (op (!cursesSupport && stdenv.isDarwin) readline);

  enableParallelBuilding = true;

  patches = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.2.0/railsexpress/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.2.0/railsexpress/02-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.2.0/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.2.0/railsexpress/04-backport-401c8bb.patch"
    "${patchSet}/patches/ruby/2.2.0/railsexpress/05-fix-packed-bitfield-compat-warning-for-older-gccs.patch"
  ];

  # Ruby >= 2.1.0 tries to download config.{guess,sub}
  postPatch = ''
    rm tool/config_files.rb
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
    teenyVersion = "0";
    patchLevel = "0";
    rubyEngine = "ruby";
    libPath = "lib/${rubyEngine}/${majorVersion}.${minorVersion}.${teenyVersion}";
    gemPath = "lib/${rubyEngine}/gems/${majorVersion}.${minorVersion}.${teenyVersion}";
  };
}
