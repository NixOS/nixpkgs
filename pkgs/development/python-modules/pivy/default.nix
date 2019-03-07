{ stdenv
, buildPythonPackage
, fetchgit
, cmake
, swig
, coin3d
, soqt
, qt5
, libGLU_combined
, xorg
}:

buildPythonPackage rec {
  version = "0.6.5a1pre";
  pname = "pivy";

  src = fetchgit {
    url = "https://github.com/FreeCAD/pivy.git";
    rev = "406bc58e298d05f0847fc732f388c0993d28c0f8";
    sha256 = "0qn1jsr280bvpp6m5lffsqg7wx3hz710fqflfh3whmx93ihcd4v6";
  };

  nativeBuildInputs = [ cmake swig qt5.qtbase.dev ];
  buildInputs = with xorg; [
    coin3d soqt qt5.qtbase libGLU_combined
    libXi libXext libSM libICE libX11
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://pivy.coin3d.org/;
    description = "A Python binding for Coin";
    maintainers = [ maintainers.FlorianFranzen ];
    license = licenses.bsd0;
  };
}
