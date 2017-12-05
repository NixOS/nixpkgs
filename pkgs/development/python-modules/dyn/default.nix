{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestcov, mock, pytestpep8
, pytest_xdist, covCore, glibcLocales }:

buildPythonPackage rec {
  pname = "dyn";
  version = "1.8.0";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ab3cd9a1478674cf2d2aa6740fb0ddf77daaa9ab3e35e5d2bc92f60301f8523";
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
