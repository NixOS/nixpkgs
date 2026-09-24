{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools_80,
  plaster,
  pastedeploy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "plaster-pastedeploy";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "plaster_pastedeploy";
    inherit version;
    hash = "sha256-viYubS5BpyZIddqi/ihQy7BhVyi83JKCj9xyc244FBI=";
  };

  build-system = [ setuptools_80 ];

  dependencies = [
    plaster
    pastedeploy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "PasteDeploy binding to the plaster configuration loader";
    homepage = "https://github.com/Pylons/plaster_pastedeploy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
