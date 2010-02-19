{stdenv, fetchurl, mesa, tcl, tk, file}:

stdenv.mkDerivation rec {
  name = "opencascade-6.3.0";
  src = fetchurl {
    url = http://files.opencascade.com/OCC_6.3_release/OpenCASCADE_src.tgz;
    md5 = "52778127974cb3141c2827f9d40d1f11";
  };

  buildInputs = [ mesa tcl tk file ];

  preConfigure = ''
    cd ros
  '';

  postInstall = ''
    mv $out/inc $out/include
    ensureDir $out/share/doc/${name}
    cp -R ../doc $out/share/doc/${name}
  '';

  meta = {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = http://www.opencascade.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
