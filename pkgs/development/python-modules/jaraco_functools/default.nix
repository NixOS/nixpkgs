{ lib
, buildPythonPackage
, fetchPypi
, more-itertools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "3.5.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0K3PkXEKCFPv6fI6ePrVhr9n31cvDW2OD6NtKJrhwdk=";
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
