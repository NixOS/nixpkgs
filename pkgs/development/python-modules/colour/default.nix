{ stdenv, buildPythonPackage, fetchPypi, d2to1 }:

buildPythonPackage rec {
  pname = "colour";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w1j43l76zw10dvs2kk7jz7kqj2ss7gfgfdxyls27pckwin89gxb";
  };

  buildInputs = [ d2to1 ];

  meta = with stdenv.lib; {
    description = "Converts and manipulates common color representation (RGB, HSV, web, ...)";
    homepage = https://github.com/vaab/colour;
    license = licenses.bsd2;
  };
}
