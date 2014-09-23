{ stdenv, fetchurl, fetchFromGitHub
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? false
, groff, docSupport ? false
, libyaml, yamlSupport ? true
, ruby_1_9_3, autoreconfHook, bison, useRailsExpress ? true
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  baseruby = ruby_1_9_3.override { useRailsExpress = false; };
in

stdenv.mkDerivation rec {
  version = with passthru; "${majorVersion}.${minorVersion}.${teenyVersion}-p${patchLevel}";

  name = "ruby-${version}";

  src = if useRailsExpress then fetchFromGitHub {
    owner  = "ruby";
    repo   = "ruby";
    rev    = "v1_9_3_${passthru.patchLevel}";
    sha256 = "040x67snfjrql5j7blizpm9j58jhwvh00v8h1h59aq90h52lkj68";
  } else fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/1.9/${name}.tar.bz2";
    sha256 = "0k7g0ahicjnd4sij2pml1p1dcb95ms3k3j1k3169n02kzz9qwn7g";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  buildInputs = ops useRailsExpress [ autoreconfHook bison ]
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

  patches = [
    ./ruby19-parallel-install.patch
    ./bitperfect-rdoc.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/01-fix-make-clean.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/02-railsbench-gc.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/03-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/04-fork-support-for-gc-logging.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/05-track-live-dataset-size.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/06-webrick_204_304_keep_alive_fix.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/07-export-a-few-more-symbols-for-ruby-prof.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/08-thread-variables.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/09-faster-loading.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/10-falcon-st-opt.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/11-falcon-sparse-array.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/12-falcon-array-queue.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/13-railsbench-gc-fixes.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/14-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/15-configurable-fiber-stack-sizes.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/16-backport-psych-20.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/17-fix-missing-c-return-event.patch"
    "${patchSet}/patches/ruby/1.9.3/p547/railsexpress/18-fix-process-daemon-call.patch"
  ];

  configureFlags = [ "--enable-shared" "--enable-pthread" ]
    ++ op useRailsExpress "--with-baseruby=${baseruby}/bin/ruby"
    # on darwin, we have /usr/include/tk.h -- so the configure script detects
    # that tk is installed
    ++ ( if stdenv.isDarwin then [ "--with-out-ext=tk " ] else [ ]);

  installFlags = stdenv.lib.optionalString docSupport "install-doc";

  CFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.7";

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
    license     = "Ruby";
    homepage    = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.all;
  };

  passthru = rec {
    majorVersion = "1";
    minorVersion = "9";
    teenyVersion = "3";
    patchLevel = "547";
    libPath = "lib/ruby/${majorVersion}.${minorVersion}";
    gemPath = "lib/ruby/gems/${majorVersion}.${minorVersion}";
  };
}
