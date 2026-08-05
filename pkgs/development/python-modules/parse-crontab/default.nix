{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytz,
  python-dateutil,
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

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    python-dateutil
  ];

  pythonImportsCheck = [ "crontab" ];

  meta = {
    description = "Parse Unix crontab schedule expressions";
    homepage = "https://github.com/josiahcarlson/parse-crontab";
    changelog = "https://github.com/josiahcarlson/parse-crontab/blob/${finalAttrs.version}/changelog.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
