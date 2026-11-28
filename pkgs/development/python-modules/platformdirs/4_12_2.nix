{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  appdirs,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "platformdirs";
  version = "4.12.2";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6rX3AnGkkO90YYuzFPu4bjx+gvo7nJIsLqDgoaFV0yk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    appdirs
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    unset XDG_DATA_DIRS
  '';

  pythonImportsCheck = [ "platformdirs" ];

  meta = {
    description = "Determine platform-specific dirs, e.g. cache and config dirs";
    homepage = "https://platformdirs.readthedocs.io/";
    license = lib.licenses.mit;
  };
}
