{ stdenv, buildPythonPackage, fetchPypi, fetchurl
, click
, colorama
, pyjwt
, pyserial
, requests
, semantic-version
}:

buildPythonPackage rec {
  pname = "apio";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25f6a13cf037d60cbf6612311de0f0553c26865d63a2ec7686af428826a90663";
  };

  patches = [
    (fetchurl {
      url = https://github.com/FPGAwars/apio/commit/f8dd8774de0e6f3d57d72214fa6675f0a9c6f310.patch;
      sha256 = "0yf1shi6bb6cn1ikj1g38hf4752rqi082x0y5q66rm29yjp7jy6r";
    })
  ];

  propagatedBuildInputs = [ requests colorama pyjwt pyserial click semantic-version ];

  meta = with stdenv.lib; {
    description = "Open source ecosystem for open FPGA boards";
    homepage = "https://github.com/FPGAwars/apio";
    license = licenses.gpl2;
  };
}
