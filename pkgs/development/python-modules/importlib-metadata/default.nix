{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, setuptools-scm
, typing-extensions
, toml
, zipp
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "5.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    hash = "sha256-QE1I1iu6C3p3/51AXv2RUBvvLmf/Ss4L7UCgzyjDx80=";
  };

  nativeBuildInputs = [
    setuptools # otherwise cross build fails
    setuptools-scm
  ];

  propagatedBuildInputs = [
    toml
    zipp
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # Cyclic dependencies due to pyflakefs
  doCheck = false;

  pythonImportsCheck = [
    "importlib_metadata"
  ];

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
