{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-quantities";
    repo = "python-quantities";
    rev = "refs/tags/v${version}";
    hash = "sha256-N20xfzGtM0VnfkJtzMytNLySTkgVz2xf1nEJxlwBSCI=";
  };

  patches = [
    (fetchpatch2 {
      name = "prevent-arbitrary-code-eval.patch";
      url = "https://github.com/python-quantities/python-quantities/pull/236.patch";
      hash = "sha256-H1tOfXqNMIKY01m6o2PsfZG0CvnWNxW2qIWA5ce1lRk=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # test fails with numpy 1.24
    "test_mul"
  ];

  pythonImportsCheck = [ "quantities" ];

  meta = with lib; {
    description = "Quantities is designed to handle arithmetic and conversions of physical quantities";
    homepage = "https://python-quantities.readthedocs.io/";
    changelog = "https://github.com/python-quantities/python-quantities/blob/v${version}/CHANGES.txt";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
