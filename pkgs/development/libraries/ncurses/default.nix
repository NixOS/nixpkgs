{ lib, stdenv, fetchurl, unicode ? true }:

let
  /* C++ bindings fail to build on `i386-pc-solaris2.11' with GCC 3.4.3:
     <http://bugs.opensolaris.org/bugdatabase/view_bug.do?bug_id=6395191>.
     It seems that it could be worked around by #including <wchar.h> in the
     right place, according to
     <http://mail.python.org/pipermail/python-bugs-list/2006-September/035362.html>,
     but this is left as an exercise to the reader.
     So disable them for now.  */
  cxx = !stdenv.isSunOS;
in
stdenv.mkDerivation rec {
  name = "ncurses-5.9";

  src = fetchurl {
    url = "mirror://gnu/ncurses/${name}.tar.gz";
    sha256 = "0fsn7xis81za62afan0vvm38bvgzg5wfmv1m86flqcj0nj7jjilh";
  };

  patches = [ ./patch-ac ];

  configureFlags = ''
    --with-shared --without-debug --enable-pc-files --enable-symlinks
    ${if unicode then "--enable-widec" else ""}${if cxx then "" else "--without-cxx-binding"}
  '';

  # PKG_CONFIG_LIBDIR is where the *.pc files will be installed. If this
  # directory doesn't exist, the configure script will disable installation of
  # *.pc files. The configure script usually (on LSB distros) pick $(path of
  # pkg-config)/../lib/pkgconfig. On NixOS that path doesn't exist and is not
  # the place we want to put *.pc files from other packages anyway. So we must
  # tell it explicitly where to install with PKG_CONFIG_LIBDIR.
  preConfigure = ''
    export configureFlags="$configureFlags --includedir=$out/include"
    export PKG_CONFIG_LIBDIR="$out/lib/pkgconfig"
    mkdir -p "$PKG_CONFIG_LIBDIR"
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace -no-cpp-precomp ""
  '';

  selfNativeBuildInput = true;

  enableParallelBuilding = true;

  preBuild =
    # On Darwin, we end up using the native `sed' during bootstrap, and it
    # fails to run this command, which isn't needed anyway.
    lib.optionalString (!stdenv.isDarwin)
      ''sed -e "s@\([[:space:]]\)sh @\1''${SHELL} @" -i */Makefile Makefile'';

  # When building a wide-character (Unicode) build, create backward
  # compatibility links from the the "normal" libraries to the
  # wide-character libraries (e.g. libncurses.so to libncursesw.so).
  postInstall = if unicode then ''
    ${if cxx then "chmod 644 $out/lib/libncurses++w.a" else ""}
    for lib in curses ncurses form panel menu; do
      if test -e $out/lib/lib''${lib}w.a; then
        rm -f $out/lib/lib$lib.so
        echo "INPUT(-l''${lib}w)" > $out/lib/lib$lib.so
        ln -svf lib''${lib}w.a $out/lib/lib$lib.a
        ln -svf lib''${lib}w.so.5 $out/lib/lib$lib.so.5
        ln -svf ''${lib}w.pc $out/lib/pkgconfig/$lib.pc
      fi
    done;
    ln -svf . $out/include/ncursesw
    ln -svf ncursesw5-config $out/bin/ncurses5-config
  '' else "";

  postFixup = lib.optionalString stdenv.isDarwin "rm $out/lib/*.so";

  meta = {
    description = "GNU Ncurses, a free software emulation of curses in SVR4 and more";

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

    license = lib.licenses.mit;

    maintainers = [ lib.maintainers.ludo ];
    platforms = lib.platforms.all;
  };
}
