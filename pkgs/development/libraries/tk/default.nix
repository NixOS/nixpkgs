{ stdenv, fetchurl, pkgconfig, tcl, libXft, fontconfig }:

stdenv.mkDerivation {
  name = "tk-${tcl.version}";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
    sha256 = "1h96vp15zl5xz0d4qp6wjyrchqmrmdm3q5k22wkw9jaxbvw9vy88";
  };

  patches = [ ./different-prefix-with-tcl.patch ];

  postInstall = ''
    ln -s $out/bin/wish* $out/bin/wish
  '';

  preConfigure = ''
    cd unix
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
  ];

  buildInputs = [ pkgconfig tcl libXft ]
    ++ stdenv.lib.optional stdenv.isDarwin fontconfig;

  NIX_CFLAGS_LINK = if stdenv.isDarwin then "-lfontconfig" else null;

  inherit tcl;

  passthru = rec {
    inherit (tcl) release version;
    libPrefix = "tk${tcl.release}";
    libdir = "lib/${libPrefix}";
  };

  meta = with stdenv.lib; {
    description = "A widget toolkit that provides a library of basic elements for building a GUI in many different programming languages";
    homepage = http://www.tcl.tk/;
    license = licenses.tcltk;
    platforms = platforms.all;
    maintainers = with maintainers; [ lovek323 wkennington ];
  };
}
