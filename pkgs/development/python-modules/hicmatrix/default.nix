{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cooler,
  intervaltree,
  numpy,
  pandas,
  scipy,
  tables,

  # tests
  pytestCheckHook,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "hicmatrix";
  version = "17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deeptools";
    repo = "HiCMatrix";
    tag = finalAttrs.version;
    hash = "sha256-cCp4p7o+mk/kkEILosaN16OYIln6frZxrDKICSaBel4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cooler
    intervaltree
    numpy
    pandas
    scipy
    tables
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "hicmatrix" ];

  meta = {
    description = "Helper package which implements HiCMatrix class for HiCExplorer, pyGenomeTracks and scHiCExplorer";
    homepage = "https://github.com/deeptools/HiCMatrix";
    changelog = "https://github.com/deeptools/HiCMatrix/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
