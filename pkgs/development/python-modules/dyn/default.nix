{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestcov, mock, pytestpep8
, pytest_xdist, covCore }:

buildPythonPackage rec {
  pname = "dyn";
  version = "1.8.1";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e112149d48b4500c18b3cfb6e0e6e780bb5aa0e56ff87cac412280200b9ec8bf";
  };

  buildInputs = [  ];

  checkInputs = [
    pytest
    pytestcov
    mock
    pytestpep8
    pytest_xdist
    covCore
  ];
  # Disable checks because they are not stateless and require internet access.
  doCheck = false;


  meta = with stdenv.lib; {
    description = "Dynect dns lib";
    homepage = "http://dyn.readthedocs.org/en/latest/intro.html";
    license = licenses.bsd3;
  };
}
