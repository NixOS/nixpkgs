{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  updateAutotoolsGnuConfigScriptsHook,
  ncurses,
  pkg-config,
  abiVersion ? "6",
  enableStatic ? stdenv.hostPlatform.isStatic,
  withCxx ? !stdenv.hostPlatform.useAndroidPrebuilt,
  mouseSupport ? false,
  gpm,
  withTermlib ? false,
  unicodeSupport ? true,
  testers,
  binlore,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.5";
  pname = "ncurses" + lib.optionalString (abiVersion == "5") "-abi5-compat";

  src = fetchurl {
    url = "https://invisible-island.net/archives/ncurses/ncurses-${finalAttrs.version}.tar.gz";
    hash = "sha256-E22RvCaamleF5fnpgLx2q1dCj2BM4+WlqQzrx2eXHMY=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];
  setOutputFlags = false; # some aren't supported

  patches = [
    # linux-gnuabielfv{1,2} is not in ncurses' list of GNU-ish targets (or smth like that?).
    # Causes some defines (_XOPEN_SOURCE=600, _DEFAULT_SOURCE) to not get set, so wcwidth is not exposed by system headers, which causes a FTBFS.
    # Reported and fix submitted to upstream in https://lists.gnu.org/archive/html/bug-ncurses/2025-07/msg00040.html
    # Backported to the 6.5 release (dropped some hunks for code that isn't in this release yet)
    ./1001-ncurses-Support-gnuabielfv1-2.patch
  ];

  postPatch = ''
    sed -i '1i #include <stdbool.h>' include/curses.h.in
  '';

  # see other isOpenBSD clause below
  configurePlatforms =
    if stdenv.hostPlatform.isOpenBSD then
      [ "build" ]
    else
      [
        "build"
        "host"
      ];

  configureFlags = [
    (lib.withFeature (!enableStatic) "shared")
    "--without-debug"
    "--enable-pc-files"
    "--enable-symlinks"
    "--with-manpage-format=normal"
    "--disable-stripping"
    "--with-versioned-syms"
  ]
  ++ lib.optional unicodeSupport "--enable-widec"
  ++ lib.optional (!withCxx) "--without-cxx"
  ++ lib.optional (abiVersion == "5") "--with-abi-version=5"
  ++ lib.optional stdenv.hostPlatform.isNetBSD "--enable-rpath"
  ++ lib.optional withTermlib "--with-termlib"
  ++ lib.optionals stdenv.hostPlatform.isWindows [
    "--enable-sp-funcs"
    "--enable-term-driver"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isUnix && enableStatic) [
    # For static binaries, the point is to have a standalone binary with
    # minimum dependencies. So here we make sure that binaries using this
    # package won't depend on a terminfo database located in the Nix store.
    "--with-terminfo-dirs=${
      lib.concatStringsSep ":" [
        "/etc/terminfo" # Debian, Fedora, Gentoo
        "/lib/terminfo" # Debian
        "/usr/share/terminfo" # upstream default, probably all FHS-based distros
        "/run/current-system/sw/share/terminfo" # NixOS
      ]
    }"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "--with-build-cc=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
  ]
  ++ (lib.optionals (stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17")
    [
      # lld17+ passes `--no-undefined-version` by default and makes this a hard
      # error; ncurses' `resulting.map` version script references symbols that
      # aren't present.
      #
      # See: https://lists.gnu.org/archive/html/bug-ncurses/2024-05/msg00086.html
      #
      # For now we allow this with `--undefined-version`:
      "LDFLAGS=-Wl,--undefined-version"
    ]
  )
  ++ lib.optionals stdenv.hostPlatform.isOpenBSD [
    # If you don't specify the version number in the host specification, a branch gets taken in configure
    # which assumes that your openbsd is from the 90s, leading to a truly awful compiler/linker configuration.
    # No, autoreconfHook doesn't work.
    "--host=${stdenv.hostPlatform.config}${stdenv.cc.libc.version}"
  ]
  # Without this override, the upstream configure system results in
  #
  #     typedef unsigned char NCURSES_BOOL;
  #     #define bool NCURSES_BOOL;
  #
  # Which breaks C++ bindings:
  #
  #      > /nix/store/[...]-gcc-15.1.0/include/c++/15.1.0/cstddef:81:21: error: redefinition of 'struct std::__byte_operand<unsigned char>'
  #      >    81 |   template<> struct __byte_operand<unsigned char> { using __type = byte; };
  #      >       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #      > /nix/store/[...]-gcc-15.1.0/include/c++/15.1.0/cstddef:78:21: note: previous definition of 'struct std::__byte_operand<unsigned char>'
  #      >    78 |   template<> struct __byte_operand<bool> { using __type = byte; };
  #
  ++ [
    "cf_cv_type_of_bool=bool"
  ];

  # Only the C compiler, and explicitly not C++ compiler needs this flag on solaris:
  CFLAGS = lib.optionalString stdenv.hostPlatform.isSunOS "-D_XOPEN_SOURCE_EXTENDED";

  strictDeps = true;

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    pkg-config
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # for `tic`, build already depends on for build `cc` so it's weird the build doesn't just build `tic`.
    ncurses
  ];

  buildInputs = lib.optional (mouseSupport && stdenv.hostPlatform.isLinux) gpm;

  preConfigure = ''
    export PKG_CONFIG_LIBDIR="$dev/lib/pkgconfig"
    mkdir -p "$PKG_CONFIG_LIBDIR"
    configureFlagsArray+=(
      "--libdir=$out/lib"
      "--includedir=$dev/include"
      "--bindir=$dev/bin"
      "--mandir=$man/share/man"
      "--with-pkg-config-libdir=$PKG_CONFIG_LIBDIR"
    )
  ''
  + lib.optionalString stdenv.hostPlatform.isSunOS ''
    sed -i -e '/-D__EXTENSIONS__/ s/-D_XOPEN_SOURCE=\$cf_XOPEN_SOURCE//' \
           -e '/CPPFLAGS="$CPPFLAGS/s/ -D_XOPEN_SOURCE_EXTENDED//' \
        configure
    CFLAGS=-D_XOPEN_SOURCE_EXTENDED
  '';

  enableParallelBuilding = true;

  doCheck = false;

  postFixup =
    let
      abiVersion-extension =
        if stdenv.hostPlatform.isDarwin then "${abiVersion}.$dylibtype" else "$dylibtype.${abiVersion}";
    in
    ''
      # Determine what suffixes our libraries have
      suffix="$(awk -F': ' 'f{print $3; f=0} /default library suffix/{f=1}' config.log)"
    ''
    # When building a wide-character (Unicode) build, create backward
    # compatibility links from the the "normal" libraries to the
    # wide-character libraries (e.g. libncurses.so to libncursesw.so).
    + lib.optionalString unicodeSupport ''
      libs="$(ls $dev/lib/pkgconfig | tr ' ' '\n' | sed "s,\(.*\)$suffix\.pc,\1,g")"
      suffixes="$(echo "$suffix" | awk '{for (i=1; i < length($0); i++) {x=substr($0, i+1, length($0)-i); print x}}')"

      # Get the path to the config util
      cfg=$(basename $dev/bin/ncurses*-config)

      # symlink the full suffixed include directory
      ln -svf . $dev/include/ncurses$suffix

      for newsuffix in $suffixes ""; do
        # Create a non-abi versioned config util links
        ln -svf $cfg $dev/bin/ncurses$newsuffix-config

        # Allow for end users who #include <ncurses?w/*.h>
        ln -svf . $dev/include/ncurses$newsuffix

        for library in $libs; do
          for dylibtype in so dll dylib; do
            if [ -e "$out/lib/lib''${library}$suffix.$dylibtype" ]; then
              ln -svf lib''${library}$suffix.$dylibtype $out/lib/lib$library$newsuffix.$dylibtype
              ln -svf lib''${library}$suffix.${abiVersion-extension} $out/lib/lib$library$newsuffix.${abiVersion-extension}
              if [ "ncurses" = "$library" ]
              then
                # make libtinfo symlinks
                ln -svf lib''${library}$suffix.$dylibtype $out/lib/libtinfo$newsuffix.$dylibtype
                ln -svf lib''${library}$suffix.${abiVersion-extension} $out/lib/libtinfo$newsuffix.${abiVersion-extension}
              fi
            fi
          done
          for statictype in a dll.a la; do
            if [ -e "$out/lib/lib''${library}$suffix.$statictype" ]; then
              ln -svf lib''${library}$suffix.$statictype $out/lib/lib$library$newsuffix.$statictype
              if [ "ncurses" = "$library" ]
              then
                # make libtinfo symlinks
                ln -svf lib''${library}$suffix.$statictype $out/lib/libtinfo$newsuffix.$statictype
              fi
            fi
          done
          ln -svf ''${library}$suffix.pc $dev/lib/pkgconfig/$library$newsuffix.pc
        done
      done
    ''
    # Unconditional patches. Leading newline is to avoid mass rebuilds.
    + ''

      # add pkg-config aliases for libraries that are built-in to libncurses(w)
      for library in tinfo tic; do
        for suffix in "" ${lib.optionalString unicodeSupport "w"}; do
          ln -svf ncurses$suffix.pc $dev/lib/pkgconfig/$library$suffix.pc
        done
      done

      # move some utilities to $bin
      # these programs are used at runtime and don't really belong in $dev
      moveToOutput "bin/clear" "$out"
      moveToOutput "bin/reset" "$out"
      moveToOutput "bin/tabs" "$out"
      moveToOutput "bin/tic" "$out"
      moveToOutput "bin/tput" "$out"
      moveToOutput "bin/tset" "$out"
      moveToOutput "bin/captoinfo" "$out"
      moveToOutput "bin/infotocap" "$out"
      moveToOutput "bin/infocmp" "$out"
    '';

  preFixup = lib.optionalString (!stdenv.hostPlatform.isCygwin && !enableStatic) ''
    rm "$out"/lib/*.a
  '';

  # I'm not very familiar with ncurses, but it looks like most of the
  # exec here will run hard-coded executables. There's one that is
  # dynamic, but it looks like it only comes from executing a terminfo
  # file, so I think it isn't going to be under user control via CLI?
  # Happy to have someone help nail this down in either direction!
  # The "capability" is 'iprog', and I could only find 1 real example:
  # https://invisible-island.net/ncurses/terminfo.ti.html#tic-linux-s
  passthru.binlore.out = binlore.synthesize ncurses ''
    execer cannot bin/{reset,tput,tset}
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/ncurses/";
    description = "Free software emulation of curses in SVR4 and more";
    longDescription = ''
      The Ncurses (new curses) library is a free software emulation of curses in
      System V Release 4.0, and more. It uses Terminfo format, supports pads and
      color and multiple highlights and forms characters and function-key
      mapping, and has all the other SYSV-curses enhancements over BSD Curses.

      The ncurses code was developed under GNU/Linux. It has been in use for
      some time with OpenBSD as the system curses library, and on FreeBSD and
      NetBSD as an external package. It should port easily to any
      ANSI/POSIX-conforming UNIX. It has even been ported to OS/2 Warp!
    '';
    license = licenses.mit;
    pkgConfigModules =
      let
        base = [
          "form"
          "menu"
          "ncurses"
          "panel"
        ]
        ++ lib.optional withCxx "ncurses++";
      in
      base ++ lib.optionals unicodeSupport (map (p: p + "w") base);
    platforms = platforms.all;
  };

  passthru = {
    ldflags = "-lncurses";
    inherit unicodeSupport abiVersion;
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };
})
