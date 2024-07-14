{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  python-json-logger,
  jsonschema,
  ruamel-yaml,
  traitlets,
}:

buildPythonPackage rec {
  pname = "jupyter_telemetry";
  version = "0.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RFxhOuPfcNJV/j3iAvk2u6i3e0BVxDIH7fIkaKyHUxQ=";
  };

  propagatedBuildInputs = [
    python-json-logger
    jsonschema
    ruamel-yaml
    traitlets
  ];

  meta = with lib; {
    description = "Telemetry for Jupyter Applications and extensions";
    homepage = "https://jupyter-telemetry.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ chiroptical ];
  };
}
