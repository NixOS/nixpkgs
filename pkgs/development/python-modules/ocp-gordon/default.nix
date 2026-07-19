{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
  cadquery-ocp,
  numpy,
  scipy,
}:
buildPythonPackage rec {
  pname = "ocp_gordon";
  version = "0.1.18";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6n90FNMfkQp5Vw+SGP4AHPrH36ILNHmUBqQgxnne5rs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    cadquery-ocp
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "A Python library for Gordon Surface interpolation using B-splines";
    homepage = "https://pypi.org/project/ocp-gordon/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tnytown ];
  };
}
