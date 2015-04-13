{ stdenv, fetchurl, pkgconfig, tcl, libXft, fontconfig }:

stdenv.mkDerivation {
  name = "tk-8.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk8.6.4-src.tar.gz";
    sha256 = "1h96vp15zl5xz0d4qp6wjyrchqmrmdm3q5k22wkw9jaxbvw9vy88";
  };

  patches = [ ./different-prefix-with-tcl.patch ];

  postInstall = ''
    ln -s $out/bin/wish* $out/bin/wish
  '';

  configureFlags = "--with-tcl=${tcl}/lib";

  preConfigure = "cd unix";

  buildInputs = [ pkgconfig tcl libXft ]
    ++ stdenv.lib.optional stdenv.isDarwin fontconfig;

  NIX_CFLAGS_LINK = if stdenv.isDarwin then "-lfontconfig" else null;

  inherit tcl;

  passthru = {
    libPrefix = "tk8.6";
  };

  meta = {
    description = "A widget toolkit that provides a library of basic elements for building a GUI in many different programming languages";
    homepage = http://www.tcl.tk/;
    license = stdenv.lib.licenses.tcltk;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms = stdenv.lib.platforms.all;
  };
}
