{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestcov, mock, pytestpep8
, pytest_xdist, covCore, glibcLocales }:

buildPythonPackage rec {
  pname = "dyn";
  version = "1.6.4";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3843938edac38cddf8e0bd2e0e884bb1b7845c265ae3605cd9e27eb98f90956";
  };

  buildInputs = [ glibcLocales ];

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

  LC_ALL="en_US.UTF-8";

  meta = with stdenv.lib; {
    description = "Dynect dns lib";
    homepage = "http://dyn.readthedocs.org/en/latest/intro.html";
    license = licenses.bsd3;
  };
}
