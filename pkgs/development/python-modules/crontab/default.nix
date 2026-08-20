{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  python-dateutil,
  pytz,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "crontab";
  version = "1.0.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "josiahcarlson";
    repo = "parse-crontab";
    tag = finalAttrs.version;
    hash = "sha256-iZS4vkfp93BK5wp1S3qCg0bC7NcT7o5/nNMRI+SXTws=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crontab" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parse and use crontab schedules in Python";
    homepage = "https://github.com/josiahcarlson/parse-crontab";
    changelog = "https://github.com/josiahcarlson/parse-crontab/blob/${finalAttrs.src.rev}/changelog.txt";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
