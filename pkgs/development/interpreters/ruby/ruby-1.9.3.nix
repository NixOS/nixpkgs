{ stdenv, lib, fetchurl, fetchFromGitHub
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? true
, groff, docSupport ? false
, libyaml, yamlSupport ? true
, ruby_1_9_3, autoreconfHook, bison, useRailsExpress ? true
, libiconv, libobjc
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
    sha256 = "1r9xzzxmci2ajb34qb4y1w424mz878zdgzxkfp9w60agldxnb36s";
  } else fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/1.9/${name}.tar.bz2";
    sha256 = "07kpvv2z7g6shflls7fyfga8giifahwlnl30l49qdm9i6izf7idh";
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
    ++ (op (!cursesSupport && stdenv.isDarwin) readline)
    ++ (ops stdenv.isDarwin [ libiconv libobjc ]);

  enableParallelBuilding = true;

  patches = [
    ./ruby19-parallel-install.patch
    ./bitperfect-rdoc.patch
  ] ++ ops useRailsExpress [
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/01-fix-make-clean.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/02-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/03-railsbench-gc.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/04-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/05-fork-support-for-gc-logging.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/06-track-live-dataset-size.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/07-webrick_204_304_keep_alive_fix.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/08-export-a-few-more-symbols-for-ruby-prof.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/09-thread-variables.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/10-faster-loading.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/11-falcon-st-opt.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/12-falcon-sparse-array.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/13-falcon-array-queue.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/14-railsbench-gc-fixes.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/15-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/16-configurable-fiber-stack-sizes.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/17-backport-psych-20.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/18-fix-missing-c-return-event.patch"
    "${patchSet}/patches/ruby/1.9.3/p${passthru.patchLevel}/railsexpress/19-fix-process-daemon-call.patch"
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
  '' + lib.optionalString useRailsExpress ''
    rbConfig=$(find $out/lib/ruby -name rbconfig.rb)

    # Prevent the baseruby from being included in the closure.
    sed -i '/^  CONFIG\["BASERUBY"\]/d' $rbConfig
    sed -i "s|'--with-baseruby=${baseruby}/bin/ruby'||" $rbConfig
  '';

  meta = with stdenv.lib; {
    license     = licenses.ruby;
    homepage    = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
  };

  passthru = rec {
    majorVersion = "1";
    minorVersion = "9";
    teenyVersion = "3";
    patchLevel = "551";
    rubyEngine = "ruby";
    libPath = "lib/${rubyEngine}/${majorVersion}.${minorVersion}.${teenyVersion}";
    gemPath = "lib/${rubyEngine}/gems/${majorVersion}.${minorVersion}.${teenyVersion}";
  };
}
