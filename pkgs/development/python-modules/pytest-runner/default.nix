{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x0d9n40lsiphblbs61rdc0d5r31f6vh0vcahqdv0mffakbnrb80";
  };

  buildInputs = [ pytest setuptools_scm ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://github.com/pytest-dev/pytest-runner;
    description = "Setup scripts can use pytest-runner to add setup.py test support for pytest runner";
  };
}
