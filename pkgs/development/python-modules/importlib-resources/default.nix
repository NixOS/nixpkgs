{ lib
, isPy27
, buildPythonPackage
, fetchPypi
, setuptools-scm
, importlib-metadata
, typing ? null
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "importlib-resources";
  version = "5.6.0";
  format = "pyproject";
  disabled = isPy27;

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    sha256 = "sha256-G5MjjL8jtM3jQkDdgyHZnpvy60vJHAyZsohig+e6rYU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    importlib-metadata
  ] ++ lib.optional (pythonOlder "3.5") [
    typing
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [
    "importlib_resources"
  ];

  meta = with lib; {
    description = "Read resources from Python packages";
    homepage = "https://importlib-resources.readthedocs.io/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
