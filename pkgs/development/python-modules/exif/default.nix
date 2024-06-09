{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pythonOlder,
  plum-py,
  pytestCheckHook,
  baseline,
}:

buildPythonPackage rec {
  pname = "exif";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "TNThieding";
    repo = "exif";
    rev = "refs/tags/v${version}";
    hash = "sha256-uiHL3m0C6+YnAHRLwzMCSzffrQsSyVcuem6FBtTLxek=";
  };

  propagatedBuildInputs = [ plum-py ];

  nativeCheckInputs = [
    pytestCheckHook
    baseline
  ];

  pythonImportsCheck = [ "exif" ];

  meta = with lib; {
    description = "Read and modify image EXIF metadata using Python";
    homepage = "https://gitlab.com/TNThieding/exif";
    changelog = "https://gitlab.com/TNThieding/exif/-/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
