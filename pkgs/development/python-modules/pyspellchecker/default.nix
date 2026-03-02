{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyspellchecker";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyspellchecker";
    tag = "v${version}";
    hash = "sha256-xUCfRI7GcwH7mC8IDX4HCHtKyuOnOZx+kxPRm89X87w=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pure python spell checking";
    homepage = "https://github.com/barrust/pyspellchecker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
