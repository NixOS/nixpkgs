{ lib
, fetchurl
, libGL
, tcl
, tk
, libX11
, libXmu
}:

tcl.mkTclDerivation rec {
  pname = "togl";
  version = "2.0";

  src = fetchurl {
    url = "mirror://sourceforge.net/projects/togl/files/Togl/${version}/Togl${version}-src.tar.gz";
    sha256 = "sha256-t9SpC7rTrKYY1QXumef9j7BMgp9jIx3aI2D1V7o/dhA=";
  };

  postPatch = ''
    sed -i "s|\".*/generic/tclInt.h\"|\"${tcl}/include/tclInt.h\"|" configure
    sed -i "s|\".*/generic/tkInt.h\"|\"${tk.dev}/include/tkInt.h\"|" configure
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
  ];

  buildInputs = [
    tcl
    tk.dev
    libGL
    libX11
    libXmu
  ];

  postInstall = ''
    ln -s $out/lib/Togl2.0/libTogl2.0.so $out/lib/libTogl.so
  '';

  meta = with lib; {
    description = "Tk widget for OpenGL rendering";
    homepage = "https://togl.sourceforge.net/";
    license = licenses.tcltk;
    maintainers = with maintainers; [ kayhide ];
    platforms = lib.platforms.unix;
  };
}
