{ stdenv
, buildPythonPackage
, fetchhg
, pkgs
, isPy3k
}:

buildPythonPackage rec {
  version = "20101207";
  pname = "pivy";
  disabled = isPy3k; # Judging from SyntaxError

  src = fetchhg {
    url = "https://bitbucket.org/Coin3D/pivy";
    rev = "8eab90908f2a3adcc414347566f4434636202344";
    sha256 = "18n14ha2d3j3ghg2f2aqnf2mks94nn7ma9ii7vkiwcay93zm82cf";
  };

  buildInputs = with pkgs; with xorg; [
    swig1 coin3d soqt libGLU_combined
    libXi libXext libSM libICE libX11
  ];

  meta = with stdenv.lib; {
    homepage = http://pivy.coin3d.org/;
    description = "A Python binding for Coin";
    license = licenses.bsd0;
  };

}
