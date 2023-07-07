{ lib
, buildPythonPackage
, fetchPypi
, more-itertools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "3.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lho74Rq67O5fWrjdWJY4voMEzEy5E2H+Xmg/S22ft6M=";
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
