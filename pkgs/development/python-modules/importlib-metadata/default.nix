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
  version = "6.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    hash = "sha256-41S+3rYO+mr/3MiuEhtzVEp6p0FW0EcxGUj21xHNN40=";
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
