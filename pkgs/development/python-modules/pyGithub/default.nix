{ lib, stdenv
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
  version = "1.54.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "1nl74bp5ikdnrc8xq0qr25ryl1mvarf0xi43k8w5jzlrllhq0nkq";
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
