{ stdenv, fetchurl, readline, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "gnu-apl";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnu/apl/apl-${version}.tar.gz";
    sha256 = "1jxvv2h3y1am1fw6r5sn3say1n0dj8shmscbybl0qhqdia2lqkql";
  };

  buildInputs = [ readline gettext ncurses ];

  # Needed with GCC 7
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isGNU "-Wno-error=int-in-bool-context"
    + stdenv.lib.optionalString stdenv.cc.isClang "-Wno-error=null-dereference";

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/LApack.cc --replace "malloc.h" "malloc/malloc.h"
  '';

  postInstall = ''
    cp -r support-files/ $out/share/doc/
    find $out/share/doc/support-files -name 'Makefile*' -delete
  '';

  meta = with stdenv.lib; {
    description = "Free interpreter for the APL programming language";
    homepage    = https://www.gnu.org/software/apl/;
    license     = licenses.gpl3Plus;
    maintainers = [ maintainers.kovirobi ];
    platforms   = with platforms; linux ++ darwin;
    inherit version;

    longDescription = ''
      GNU APL is a free interpreter for the programming language APL, with an
      (almost) complete implementation of ISO standard 13751 aka.  Programming
      Language APL, Extended.  GNU APL was written and is being maintained by
      Jürgen Sauermann.
    '';
  };
}
