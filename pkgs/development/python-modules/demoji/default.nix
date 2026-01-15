{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  ujson,
}:

buildPythonPackage rec {
  pname = "demoji";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bsolomon1124";
    repo = "demoji";
    tag = "v${version}";
    hash = "sha256-ojy4JiM6xvP9J40Z5uFCMUZvZtLZ1le2p/2/NfAUAtk=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [ setuptools ];

  optional-dependencies = {
    ujson = [ ujson ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "demoji" ];

  meta = {
    description = "Module to find/replace/remove emojis in text strings";
    homepage = "https://github.com/bsolomon1124/demoji";
    changelog = "https://github.com/bsolomon1124/demoji/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
