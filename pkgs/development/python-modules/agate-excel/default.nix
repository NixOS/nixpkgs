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
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = "agate-excel";
    tag = finalAttrs.version;
    hash = "sha256-sKy7NaRhJ4KYOOUKuNs0SGutUn8XEmSeQFQ/57gTGCg=";
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
