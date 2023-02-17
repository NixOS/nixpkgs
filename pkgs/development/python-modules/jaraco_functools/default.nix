{ lib
, buildPythonPackage
, fetchPypi
, more-itertools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "3.5.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RbBcFY860ocxB1VW/9R0m9JU7Gf5Hh6zZ9z+v/EVHbQ=";
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
