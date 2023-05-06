{ lib, buildPythonPackage, fetchFromGitLab, isPy3k, plum-py, pytestCheckHook, baseline }:

buildPythonPackage rec {
  pname = "exif";
  version = "1.3.5";
  disabled = !isPy3k;

  src = fetchFromGitLab {
    owner = "TNThieding";
    repo = "exif";
    rev = "v${version}";
    hash = "sha256-XSORawioXo8oPVZ3Jnxqa6GFIxnQZMT0vJitdmpBj0E=";
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
