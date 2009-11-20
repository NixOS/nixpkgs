{stdenv, fetchurl, unicode ? true}:

stdenv.mkDerivation rec {
  name = "ncurses-5.7";
  
  src = fetchurl {
    url = "mirror://gnu/ncurses/${name}.tar.gz";
    sha256 = "1x4q6kma6zgg438llbgiac3kik7j2lln9v97jdffv3fyqyjxx6qa";
  };
  
  configureFlags = ''
    --with-shared --includedir=''${out}/include --without-debug
    ${if unicode then "--enable-widec" else ""}
  '';

  selfNativeBuildInput = true;
    
  preBuild = ''sed -e "s@\([[:space:]]\)sh @\1''${SHELL} @" -i */Makefile Makefile'';

  # When building a wide-character (Unicode) build, create backward
  # compatibility links from the the "normal" libraries to the
  # wide-character libraries (e.g. libncurses.so to libncursesw.so).
  postInstall = if unicode then ''
    chmod -v 644 $out/lib/libncurses++w.a
    for lib in curses ncurses form panel menu; do
      if test -e $out/lib/lib''${lib}w.a; then
        rm -vf $out/lib/lib$lib.so
        echo "INPUT(-l''${lib}w)" > $out/lib/lib$lib.so
        ln -svf lib''${lib}w.a $out/lib/lib$lib.a
        ln -svf lib''${lib}w.so.5 $out/lib/lib$lib.so.5
      fi
    done;
  '' else "";

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

    license = "X11";
  };
}
