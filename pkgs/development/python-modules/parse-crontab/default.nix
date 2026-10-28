{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  python-dateutil,
  pytz,
  nix-update-script,
}:

# Distributed on PyPI as "crontab"; not to be confused with python-crontab,
# which is packaged as python3Packages.crontab and installs a module with the
# same name.
buildPythonPackage (finalAttrs: {
  pname = "crontab";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josiahcarlson";
    repo = "parse-crontab";
    tag = finalAttrs.version;
    hash = "sha256-iZS4vkfp93BK5wp1S3qCg0bC7NcT7o5/nNMRI+SXTws=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [ "crontab" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parse crontab schedules and compute execution times";
    homepage = "https://github.com/josiahcarlson/parse-crontab";
    license = with lib.licenses; [
      lgpl21Only
      lgpl3Only
    ];
    maintainers = with lib.maintainers; [ denzonl ];
  };
})
