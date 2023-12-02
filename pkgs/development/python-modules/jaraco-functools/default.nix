{ lib
, buildPythonPackage
, fetchPypi
, more-itertools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco-functools";
  version = "4.0.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "jaraco.functools";
    inherit version;
    hash = "sha256-wnnLJMk9aU73Jw+XDUmcq004E/TggnP5U5hlGmNPCSU=";
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
