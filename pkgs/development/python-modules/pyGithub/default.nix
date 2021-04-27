{ lib
, buildPythonPackage
, cryptography
, deprecated
, fetchFromGitHub
, httpretty
, isPy3k
, parameterized
, pyjwt
, pytestCheckHook
, requests }:

buildPythonPackage rec {
  pname = "PyGithub";
  version = "1.55";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "sha256-PuGCBFSbM91NtSzuyf0EQUr3LiuHDq90OwkSf53rSyA=";
  };

  checkInputs = [ httpretty parameterized pytestCheckHook ];
  propagatedBuildInputs = [ cryptography deprecated pyjwt requests ];

  # Test suite makes REST calls against github.com
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/PyGithub/PyGithub";
    description = "A Python (2 and 3) library to access the GitHub API v3";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jhhuh ];
  };
}
