{ buildPythonPackage
, lib
, fetchPypi
, setuptools-scm
, pythonOlder
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "1.0.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # To prevent infinite recursion with pytest
  doCheck = false;

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://github.com/pytest-dev/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
