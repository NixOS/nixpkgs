{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  plum-py,
  pytestCheckHook,
  baseline,
}:

buildPythonPackage rec {
  pname = "exif";
  version = "1.6.0";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "TNThieding";
    repo = "exif";
    tag = "v${version}";
    hash = "sha256-uiHL3m0C6+YnAHRLwzMCSzffrQsSyVcuem6FBtTLxek=";
  };

  propagatedBuildInputs = [ plum-py ];

  nativeCheckInputs = [
    pytestCheckHook
    baseline
  ];

  pythonImportsCheck = [ "exif" ];

  meta = {
    description = "Read and modify image EXIF metadata using Python";
    homepage = "https://gitlab.com/TNThieding/exif";
    changelog = "https://gitlab.com/TNThieding/exif/-/blob/v${version}/docs/release_notes.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dnr ];
  };
}
