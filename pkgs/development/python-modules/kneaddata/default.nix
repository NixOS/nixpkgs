{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kneaddata";
  version = "0.7.7-alpha";
  pyproject = true;

  dependencies = [ setuptools ];

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "kneaddata";
    rev = "refs/tags/${version}";
    hash = "sha256-8pXabwMGNZETEXP0A31SInj37pvogyKpJAaAY7aTyns=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "kneaddata/tests/ '*.py'" ];

  pythonImportsCheck = [ "kneaddata" ];

  meta = {
    description = "Quality control tool for metagenomic and metatranscriptomic sequencing data";
    homepage = "https://github.com/biobakery/kneaddata";
    changelog = "https://github.com/biobakery/kneaddata/releases";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "kneaddata";
  };
}
