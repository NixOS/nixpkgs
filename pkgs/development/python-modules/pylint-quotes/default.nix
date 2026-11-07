{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, pylint
}:

buildPythonPackage rec {
  pname = "pylint-quotes";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LWuz+ooaha86+KDKh1pxmsW823NcRXVihGmdgJwQnJU=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    pylint
  ];

  meta = {
    description = "Quote consistency checker for PyLint";
    homepage = "https://pypi.org/project/pylint-quotes/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ByteSudoer ];
  };
}
