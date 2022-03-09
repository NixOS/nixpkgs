{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, typing-extensions
, toml
, zipp
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "4.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    hash = "sha256-lR8NiltyYOnbXkHUKShbX0UekoR58Z2AgYh4Un026V4=";
  };

  nativeBuildInputs = [
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
