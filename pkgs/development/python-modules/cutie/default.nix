{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  readchar,
  colorama,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cutie";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kamik423";
    repo = "cutie";
    tag = finalAttrs.version;
    hash = "sha256-Z9GNvTrCgb+EDqlhHcOjn78Pli0Uc1HuVN2FrjTQobs=";
  };

  # https://docs.python.org/3/whatsnew/3.12.html#whatsnew312-removed-imp
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "import imp" "import types" \
      --replace-fail \
        'cutie = imp.new_module("cutie")' \
        'cutie = types.ModuleType("cutie")'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    colorama
    readchar
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cutie" ];

  meta = {
    description = "Command line User Tools for Input Easification";
    homepage = "https://github.com/kamik423/cutie";
    changelog = "https://github.com/kamik423/cutie/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gigahawk
    ];
  };
})
