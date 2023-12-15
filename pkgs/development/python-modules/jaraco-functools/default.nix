{ lib
, buildPythonPackage
, fetchPypi
, more-itertools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco-functools";
  version = "3.9.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "jaraco.functools";
    inherit version;
    hash = "sha256-ixN7D+rMF/70us7gTAEcnobyNBCZyHCh0S0743sypjg=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    more-itertools
  ];

  doCheck = false;

  pythonNamespaces = [ "jaraco" ];

  pythonImportsCheck = [ "jaraco.functools" ];

  meta = with lib; {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = "https://github.com/jaraco/jaraco.functools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
