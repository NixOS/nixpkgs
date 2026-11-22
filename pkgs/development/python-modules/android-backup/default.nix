{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycrypto,
  python,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "android-backup";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluec0re";
    repo = "android-backup-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fONMfy1SQTRuGO/VRZ28iex4tflH3XO0zLg1YjY0gzA=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycrypto ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "android_backup/tests/__main__.py" ];

  pythonImportsCheck = [ "android_backup" ];

  meta = {
    description = "Unpack and repack android backups";
    homepage = "https://github.com/bluec0re/android-backup-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
