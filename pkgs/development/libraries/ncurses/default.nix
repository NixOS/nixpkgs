{ stdenv, fetchurl

# Optional Dependencies
, gpm ? null

# Extra Options
, abiVersion ? "5"
, unicode ? true
}:

with stdenv.lib;
let
  buildShared = !stdenv.isDarwin;

  optGpm = stdenv.shouldUsePkg gpm;
in
stdenv.mkDerivation rec {
  name = "ncurses-5.9";

  src = fetchurl {
    url = "mirror://gnu/ncurses/${name}.tar.gz";
    sha256 = "0fsn7xis81za62afan0vvm38bvgzg5wfmv1m86flqcj0nj7jjilh";
  };

  patches = [ ./clang.patch ];

  buildInputs = [ optGpm ];

  configureFlags = [
    (mkWith   true        "abi-version" abiVersion)
    (mkWith   true        "cxx"         null)
    (mkWith   true        "cxx-binding" null)
    (mkWith   false       "ada"         null)
    (mkWith   true        "manpages"    null)
    (mkWith   true        "progs"       null)
    (mkWith   doCheck     "tests"       null)
    (mkWith   true        "curses-h"    null)
    (mkEnable true        "pc-files"    null)
    (mkWith   buildShared "shared"      null)
    (mkWith   true        "normal"      null)
    (mkWith   false       "debug"       null)
    (mkWith   false       "termlib"     null)
    (mkWith   false       "ticlib"      null)
    (mkWith   optGpm      "gpm"         null)
    (mkEnable true        "overwrite"   null)
    (mkEnable true        "database"    null)
    (mkWith   true        "xterm-new"   null)
    (mkEnable true        "symlinks"    null)
    (mkEnable unicode     "widec"       null)
    (mkEnable true        "ext-colors"  null)
    (mkEnable true        "ext-mouse"   null)
  ] ++ stdenv.lib.optionals stdenv.isCygwin [
    "--enable-sp-funcs"
    "--enable-term-driver"
    "--enable-const"
    "--enable-ext-colors"
    "--enable-ext-mouse"
    "--enable-reentrant"
    "--enable-colorfgbg"
    "--enable-tcap-names"
  ];

  # PKG_CONFIG_LIBDIR is where the *.pc files will be installed. If this
  # directory doesn't exist, the configure script will disable installation of
  # *.pc files. The configure script usually (on LSB distros) pick $(path of
  # pkg-config)/../lib/pkgconfig. On NixOS that path doesn't exist and is not
  # the place we want to put *.pc files from other packages anyway. So we must
  # tell it explicitly where to install with PKG_CONFIG_LIBDIR.
  preConfigure = ''
    export PKG_CONFIG_LIBDIR="$out/lib/pkgconfig"
    mkdir -p "$PKG_CONFIG_LIBDIR"
  '' + stdenv.lib.optionalString stdenv.isCygwin ''
    sed -i -e 's,LIB_SUFFIX="t,LIB_SUFFIX=",' configure
  '';

  selfNativeBuildInput = true;

  enableParallelBuilding = true;

  doCheck = false;

  # When building a wide-character (Unicode) build, create backward
  # compatibility links from the the "normal" libraries to the
  # wide-character libraries (e.g. libncurses.so to libncursesw.so).
  postInstall = if unicode then (''
    # Create a non-abi versioned config
    cfg=$(basename $out/bin/ncurses*-config)
    ln -svf $cfg $out/bin/ncursesw-config
    ln -svf $cfg $out/bin/ncurses-config

    # Allow for end users who #include <ncurses?w/*.h>
    ln -svf . $out/include/ncursesw
    ln -svf . $out/include/ncurses

    # Create non-unicode compatability
    libs="$(find $out/lib -name \*w.a | sed 's,.*lib\(.*\)w.a.*,\1,g')"
    for lib in $libs; do
      if [ -e "$out/lib/lib''${lib}w.so" ]; then
        ln -svf lib''${lib}w.so $out/lib/lib$lib.so
        ln -svf lib''${lib}w.so.${abiVersion} $out/lib/lib$lib.so.${abiVersion}
      fi
      ln -svf lib''${lib}w.a $out/lib/lib$lib.a
      ln -svf ''${lib}w.pc $out/lib/pkgconfig/$lib.pc
    done

    # Create curses compatability
    ln -svf libncursesw.so $out/lib/libcursesw.so
    ln -svf libncursesw.so $out/lib/libcurses.so
  '' + stdenv.lib.optionalString stdenv.isCygwin ''
    for lib in $libs; do
      if test -e $out/lib/lib''${lib}w.dll.a; then
          ln -svf lib''${lib}w.dll.a $out/lib/lib$lib.dll.a
      fi
    done
  '') else ''
    # Create a non-abi versioned config
    cfg=$(basename $out/bin/ncurses*-config)
    ln -svf $cfg $out/bin/ncurses-config

    # Allow for end users who #include <ncurses/*.h>
    ln -svf . $out/include/ncurses

    # Create curses compatability
    ln -svf libncurses.so $out/lib/libcurses.so
  '';

  meta = {
    description = "Free software emulation of curses in SVR4 and more";

    longDescription = ''
      The Ncurses (new curses) library is a free software emulation of
      curses in System V Release 4.0, and more.  It uses Terminfo
      format, supports pads and color and multiple highlights and
      forms characters and function-key mapping, and has all the other
      SYSV-curses enhancements over BSD Curses.

      The ncurses code was developed under GNU/Linux.  It has been in
      use for some time with OpenBSD as the system curses library, and
      on FreeBSD and NetBSD as an external package.  It should port
      easily to any ANSI/POSIX-conforming UNIX.  It has even been
      ported to OS/2 Warp!
    '';

    homepage = http://www.gnu.org/software/ncurses/;

    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.ldflags = if unicode then "-lncursesw" else "-lncurses";
}
