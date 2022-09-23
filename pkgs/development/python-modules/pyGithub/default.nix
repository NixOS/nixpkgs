{ lib
, buildPythonPackage
, cryptography
, deprecated
, fetchFromGitHub
, pynacl
, pyjwt
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "PyGithub";
  version = "1.55";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "sha256-PuGCBFSbM91NtSzuyf0EQUr3LiuHDq90OwkSf53rSyA=";
  };

  propagatedBuildInputs = [
    cryptography
    deprecated
    pynacl
    pyjwt
    requests
  ];

  # Test suite makes REST calls against github.com
  doCheck = false;
  pythonImportsCheck = [ "github" ];

  meta = with lib; {
    description = "Python library to access the GitHub API v3";
    homepage = "https://github.com/PyGithub/PyGithub";
    platforms = platforms.all;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jhhuh ];
  };
}
