{ lib, buildPythonPackage, fetchFromGitLab, isPy3k, plum-py, pytestCheckHook, baseline }:

buildPythonPackage rec {
  pname = "exif";
  version = "1.2.0";
  disabled = !isPy3k;

  src = fetchFromGitLab {
    owner = "TNThieding";
    repo = "exif";
    rev = "686857c677f489759db90b1ad61fa1cc1cac5f9a";
    sha256 = "0z2if23kmi0iyxviz32mlqs997i3dqpqfz6nznlwkhkkb6rkwwnh";
  };

  propagatedBuildInputs = [ plum-py ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "plum-py==0.3.1" "plum-py>=0.3.1"
  '';

  checkInputs = [ pytestCheckHook baseline ];

  meta = with lib; {
    description = "Read and modify image EXIF metadata using Python";
    homepage    = "https://gitlab.com/TNThieding/exif";
    license     = licenses.mit;
    maintainers = with maintainers; [ dnr ];
  };
}
