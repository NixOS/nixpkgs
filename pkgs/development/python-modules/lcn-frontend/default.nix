{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lcn-frontend";
  version = "0.2.8";
  pyproject = true;

  src = fetchPypi {
    pname = "lcn_frontend";
    inherit version;
    hash = "sha256-1NOZGV2sLlJABBa3pzfOcBanSgqQ4DQGb61nkRgNVzw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lcn_frontend" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/alengwenus/lcn-frontend/releases/tag/${version}";
    description = "LCN panel for Home Assistant";
    homepage = "https://github.com/alengwenus/lcn-frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
