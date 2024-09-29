{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  setuptools-scm,
  typing-extensions,
  toml,
  zipp,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "7.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    hash = "sha256-UJ7LKrdwcdtRN8ZV4kzrPu5m57vGV0Fl0NEU2fxLvmg=";
  };

  nativeBuildInputs = [
    setuptools # otherwise cross build fails
    setuptools-scm
  ];

  propagatedBuildInputs = [
    toml
    zipp
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  # Cyclic dependencies due to pyflakefs
  doCheck = false;

  pythonImportsCheck = [ "importlib_metadata" ];

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      fab
      AndersonTorres
    ];
  };
}
