{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  agate,
  openpyxl,
  xlrd,
  olefile,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "agate-excel";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = "agate-excel";
    tag = finalAttrs.version;
    hash = "sha256-5l27WJ6wJwd06l61SWPlWMj4X8bT3LvnQypisLvEXB0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    agate
    openpyxl
    xlrd
    olefile
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "agate" ];

  meta = {
    description = "Adds read support for excel files to agate";
    homepage = "https://github.com/wireservice/agate-excel";
    changelog = "https://github.com/wireservice/agate-excel/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
