{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pytest-subtesthack";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15kzcr5pchf3id4ikdvlv752rc0j4d912n589l4rifp8qsj19l1x";
  };

  buildInputs = [ pytest ];

  # no upstream test
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Terrible plugin to set up and tear down fixtures within the test function itself";
    homepage = https://github.com/untitaker/pytest-subtesthack;
    license = licenses.publicDomain;
  };
}
