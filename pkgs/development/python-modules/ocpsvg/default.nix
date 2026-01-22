{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytestCheckHook,
  cadquery-ocp,
  svgelements,
}:
let
  pname = "ocpsvg";
  version = "0.5.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XNjb7Iv1kNNzqCquvqskGDgYWqsE7ihZ8zudeVa7+6Y=";
  };
in
buildPythonPackage {
  inherit src pname version;
  pyproject = true;

  build-system = [
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  dependencies = [
    cadquery-ocp
    svgelements
  ];

  meta = {
    description = "Translator between OCP and svgelements";
    homepage = "https://github.com/3MFConsortium/lib3mf_python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tnytown ];
  };
}
