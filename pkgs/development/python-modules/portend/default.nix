{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
  tempora,
}:

buildPythonPackage rec {
  pname = "portend";
  version = "3.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qp1Aqx+eFL231AH0IhDfNdAXybl5kbrrGFaM7fuMZIk=";
  };

  postPatch = ''
    sed -i "/coherent\.licensed/d" pyproject.toml;
  '';

  build-system = [ setuptools-scm ];

  dependencies = [ tempora ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "portend" ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Monitor TCP ports for bound or unbound states";
    homepage = "https://github.com/jaraco/portend";
    license = lib.licenses.bsd3;
  };
}
