{ stdenv, fetchurl, fetchFromGitHub
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? false
, groff, docSupport ? false
, libyaml, yamlSupport ? true
, libffi, fiddleSupport ? true
, ruby_2_0_0, autoreconfHook, bison, useRailsExpress ? true
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  baseruby = ruby_2_0_0.override { useRailsExpress = false; };
in

stdenv.mkDerivation rec {
  version = with passthru; "${majorVersion}.${minorVersion}.${teenyVersion}-p${patchLevel}";

  name = "ruby-${version}";

  src = if useRailsExpress then fetchFromGitHub {
    owner  = "ruby";
    repo   = "ruby";
    rev    = "v2_0_0_${passthru.patchLevel}";
    sha256 = "07ccnxgiqxn5ycmq2wl7j3aqmndm4n358y35kzaivb488ayjg3pj";
  } else fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/2.0/${name}.tar.bz2";
    sha256 = "1qnqccyfhx0fykxqbzlxq0yvyvq6q9v32givyfyr303dx7bxlqh7";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  buildInputs = ops useRailsExpress [ autoreconfHook bison ]
    ++ (op fiddleSupport libffi)
    ++ (ops cursesSupport [ ncurses readline ] )
    ++ (op docSupport groff )
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

  # Fix a build failure on systems with nix store optimisation.
  # (The build process attempted to copy file a overwriting file b, where a and
  # b are hard-linked, which results in cp returning a non-zero exit code.)
  # https://github.com/NixOS/nixpkgs/issues/4266
  postUnpack = ''rm "$sourceRoot/enc/unicode/name2ctype.h"'';

  patches = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.0.0/p481/01-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.0.0/p481/02-railsexpress-gc.patch"
    "${patchSet}/patches/ruby/2.0.0/p481/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.0.0/p481/04-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.0.0/p481/05-fix-missing-c-return-event.patch"
  ];

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
  '';

  meta = {
    license = stdenv.lib.licenses.ruby;
    homepage = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
    platforms = stdenv.lib.platforms.all;
  };

  passthru = rec {
    majorVersion = "2";
    minorVersion = "0";
    teenyVersion = "0";
    patchLevel = "481";
    libPath = "lib/ruby/${majorVersion}.${minorVersion}";
    gemPath = "lib/ruby/gems/${majorVersion}.${minorVersion}";
  };
}
