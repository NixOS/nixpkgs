{ lib, buildPythonPackage, fetchPypi, setuptools_scm
, tempora, six, pytest, pytest-flake8 }:

buildPythonPackage rec {
  pname = "jaraco.logging";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lb846j7qs1hgqwkyifv51nhl3f8jimbc4lk8yn9nkaynw0vyzcg";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ tempora six ];
  checkInputs = [ pytest pytest-flake8 ];

  checkPhase = ''
    PYTHONPATH=".:$PYTHONPATH" pytest
  '';

  meta = with lib; {
    description = "Support for Python logging facility";
    homepage = https://github.com/jaraco/jaraco.logging;
    license = licenses.mit;
  };
}
