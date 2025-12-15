{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kneaddata";
  version = "0.12.1";
  pyproject = true;

  dependencies = [ setuptools ];

  src = fetchFromGitHub {
    owner = "biobakery";
    repo = "kneaddata";
    tag = version;
    hash = "sha256-biZ6lS0a81CBAAhTOb1Ol38/YagLqXA3AbMr2nBmSEw=";
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
