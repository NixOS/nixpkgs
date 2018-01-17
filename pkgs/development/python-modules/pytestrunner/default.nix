{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, pytest }:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00v7pi09q60yx0l1kzyklnmr5bp597mir85a9gsi7bdfyly3lz0g";
  };

  buildInputs = [ setuptools_scm pytest ];

  meta = with stdenv.lib; {
    description = "Invoke py.test as distutils command with dependency resolution";
    homepage = https://bitbucket.org/pytest-dev/pytest-runner;
    license = licenses.mit;
  };
}
