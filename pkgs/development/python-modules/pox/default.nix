{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06afe1a4a1dbf8b47f7ad5a3c1d8ada9104c64933a1da11338269a2bd8642778";
  };

  meta = with stdenv.lib; {
    description = "Utilities for filesystem exploration and automated builds";
    license = licenses.bsd3;
    homepage = https://github.com/uqfoundation/pox/;
  };

}
