{ stdenv, fetchurl, fetchFromGitHub
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? false
, groff, docSupport ? false
, ruby_1_8_7, autoreconfHook, bison, useRailsExpress ? true
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  baseruby = ruby_1_8_7.override { useRailsExpress = false; };
in

stdenv.mkDerivation rec {
  version = with passthru; "${majorVersion}.${minorVersion}.${teenyVersion}-p${patchLevel}";

  name = "ruby-${version}";

  src = if useRailsExpress then fetchFromGitHub {
    owner  = "ruby";
    repo   = "ruby";
    rev    = "v1_8_7_${passthru.patchLevel}";
    sha256 = "1xddhxr0j26hpxfixvhqdscwk2ri846w2129fcfwfjzvy19igswx";
  } else fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/1.8/${name}.tar.bz2";
    sha256 = "1qq7khilwkayrhwmzlxk83scrmiqfi7lgsn4c63znyvz2c1lgqxl";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  buildInputs = ops useRailsExpress [ autoreconfHook bison ]
    ++ (ops cursesSupport [ ncurses readline ] )
    ++ (op docSupport groff )
    ++ (op zlibSupport zlib)
    ++ (op opensslSupport openssl)
    ++ (op gdbmSupport gdbm);

  patches = ops useRailsExpress [
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/01-ignore-generated-files.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/02-fix-tests-for-osx.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/03-sigvtalrm-fix.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/04-railsbench-gc-patch.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/05-display-full-stack-trace.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/06-better-source-file-tracing.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/07-heap-dump-support.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/08-fork-support-for-gc-logging.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/09-track-malloc-size.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/10-track-object-allocation.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/11-expose-heap-slots.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/12-fix-heap-size-growth-logic.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/13-heap-slot-size.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/14-add-trace-stats-enabled-methods.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/15-track-live-dataset-size.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/16-add-object-size-information-to-heap-dump.patch"
    "${patchSet}/patches/ruby/1.8.7/p374/railsexpress/17-caller-for-all-threads.patch"
  ];

  configureFlags = [ "--enable-shared" "--enable-pthread" ]
    ++ op useRailsExpress "--with-baseruby=${baseruby}/bin/ruby";

  installFlags = stdenv.lib.optionalString docSupport "install-doc";

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
    license = "Ruby";
    homepage = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
  };

  passthru = rec {
    majorVersion = "1";
    minorVersion = "8";
    teenyVersion = "7";
    patchLevel = "374";
    rubyEngine = "ruby";
    libPath = "lib/${rubyEngine}/${majorVersion}.${minorVersion}.${teenyVersion}";
    gemPath = "lib/${rubyEngine}/gems/${majorVersion}.${minorVersion}.${teenyVersion}";
  };
}
