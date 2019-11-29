{ stdenv, fetchFromGitHub
, buildPythonPackage, python-jose, pyjwt, requests, deprecated, httpretty }:

buildPythonPackage rec {
  pname = "PyGithub";
  version = "1.44.1";

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "16ngnnm7xj9bd97pvyddag17dx28c5wi0gjx4ws8c8nrmf5w3iqk";
  };

  propagatedBuildInputs = [ python-jose pyjwt requests deprecated httpretty ];
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/PyGithub/PyGithub;
    description = "A Python (2 and 3) library to access the GitHub API v3";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jhhuh ];
  };
}
