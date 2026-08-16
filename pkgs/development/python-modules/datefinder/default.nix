{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  python-dateutil,
  pytz,
  regex,
}:

buildPythonPackage (finalAttrs: {
  pname = "datefinder";
  version = "0.7.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akoumjian";
    repo = "datefinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uOSwS+mHgbvEL+rTfs4Ax9NvJnhYemxFVqqDssy2i7g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    regex
    pytz
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "datefinder" ];

  meta = {
    description = "Extract datetime objects from strings";
    homepage = "https://github.com/akoumjian/datefinder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
