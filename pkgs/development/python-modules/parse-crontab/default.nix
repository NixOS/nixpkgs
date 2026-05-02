{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytz,
  python-dateutil,
  setuptools,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "crontab";
  version = "0.22.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Gsl3+xuLpbe1jm9xPNffNuYdeu5MK4CavPdq3d0t7q8=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    python-dateutil
  ];

  pythonImportsCheck = [ "crontab" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Parse Unix crontab schedule expressions";
    homepage = "https://github.com/josiahcarlson/parse-crontab";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
