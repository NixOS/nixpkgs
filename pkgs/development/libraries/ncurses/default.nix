{ lib
, stdenv
, fetchurl
, buildPackages
, ncurses
, pkg-config
, abiVersion ? "6"
, enableStatic ? stdenv.hostPlatform.isStatic
, withCxx ? !stdenv.hostPlatform.useAndroidPrebuilt
, mouseSupport ? false, gpm
, unicodeSupport ? true
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.4";
  pname = "ncurses" + lib.optionalString (abiVersion == "5") "-abi5-compat";

  src = fetchurl {
    url = "https://invisible-island.net/archives/ncurses/ncurses-${finalAttrs.version}.tar.gz";
    hash = "sha256-aTEoPZrIfFBz8wtikMTHXyFjK7T8NgOsgQCBK+0kgVk=";
  };

  outputs = [ "out" "dev" "man" ];
  setOutputFlags = false; # some aren't supported

  configureFlags = [
    (lib.withFeature (!enableStatic) "shared")
    "--without-debug"
    "--enable-pc-files"
    "--enable-symlinks"
    "--with-manpage-format=normal"
    "--disable-stripping"
    "--with-versioned-syms"
  ] ++ lib.optional unicodeSupport "--enable-widec"
    ++ lib.optional (!withCxx) "--without-cxx"
    ++ lib.optional (abiVersion == "5") "--with-abi-version=5"
    ++ lib.optional stdenv.hostPlatform.isNetBSD "--enable-rpath"
    ++ lib.optionals stdenv.hostPlatform.isWindows [
      "--enable-sp-funcs"
      "--enable-term-driver"
  ] ++ lib.optionals (stdenv.hostPlatform.isUnix && stdenv.hostPlatform.isStatic) [
      # For static binaries, the point is to have a standalone binary with
      # minimum dependencies. So here we make sure that binaries using this
      # package won't depend on a terminfo database located in the Nix store.
      "--with-terminfo-dirs=${lib.concatStringsSep ":" [
        "/etc/terminfo" # Debian, Fedora, Gentoo
        "/lib/terminfo" # Debian
        "/usr/share/terminfo" # upstream default, probably all FHS-based distros
        "/run/current-system/sw/share/terminfo" # NixOS
      ]}"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "--with-build-cc=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
  ];

  # Only the C compiler, and explicitly not C++ compiler needs this flag on solaris:
  CFLAGS = lib.optionalString stdenv.isSunOS "-D_XOPEN_SOURCE_EXTENDED";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
   # for `tic`, build already depends on for build `cc` so it's weird the build doesn't just build `tic`.
    ncurses
  ];

  buildInputs = lib.optional (mouseSupport && stdenv.isLinux) gpm;

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
  + lib.optionalString stdenv.isSunOS ''
    sed -i -e '/-D__EXTENSIONS__/ s/-D_XOPEN_SOURCE=\$cf_XOPEN_SOURCE//' \
           -e '/CPPFLAGS="$CPPFLAGS/s/ -D_XOPEN_SOURCE_EXTENDED//' \
        configure
    CFLAGS=-D_XOPEN_SOURCE_EXTENDED
  '';

  enableParallelBuilding = true;

  doCheck = false;

  postFixup = let
    abiVersion-extension = if stdenv.isDarwin then "${abiVersion}.$dylibtype" else "$dylibtype.${abiVersion}"; in
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
    pkgConfigModules = let
      base = [
        "form"
        "menu"
        "ncurses"
        "panel"
      ] ++ lib.optional withCxx "ncurses++";
    in base ++ lib.optionals unicodeSupport (map (p: p + "w") base);
    platforms = platforms.all;
  };

  passthru = {
    ldflags = "-lncurses";
    inherit unicodeSupport abiVersion;
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };
})
