{ lib, buildPythonPackage, fetchFromGitLab, isPy3k, plum-py, pytestCheckHook, baseline }:

buildPythonPackage rec {
  pname = "exif";
  version = "1.6.0";
  disabled = !isPy3k;

  src = fetchFromGitLab {
    owner = "TNThieding";
    repo = "exif";
    rev = "v${version}";
    hash = "sha256-uiHL3m0C6+YnAHRLwzMCSzffrQsSyVcuem6FBtTLxek=";
  };

  propagatedBuildInputs = [ plum-py ];

  nativeCheckInputs = [ pytestCheckHook baseline ];

  pythonImportsCheck = [ "exif" ];

  meta = with lib; {
    description = "Read and modify image EXIF metadata using Python";
    homepage    = "https://gitlab.com/TNThieding/exif";
    license     = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
