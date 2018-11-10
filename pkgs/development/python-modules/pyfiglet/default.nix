{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.7.6";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08npllxf85ccvhd27iyq2j1b813s1947q5b1x7vxv9hdni8rdmcp";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "FIGlet in pure Python";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
