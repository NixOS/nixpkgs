{ stdenv, fetchFromGitHub
, buildPythonPackage, python-jose, pyjwt, requests, deprecated, httpretty }:

buildPythonPackage rec {
  pname = "PyGithub";
  version = "1.43.8";

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "1625v558xga5mwhl9jqmibywy5qafmg1vqrirqz6zfq1la1d22mw";
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
