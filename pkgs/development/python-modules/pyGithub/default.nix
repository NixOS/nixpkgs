{ stdenv, fetchFromGitHub
, buildPythonPackage, python-jose, pyjwt, requests, deprecated, httpretty }:

buildPythonPackage rec {
  pname = "PyGithub";
  version = "1.45";

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "1aiyqwdxpcr7yzz7aqmmjn1g2ajs5bpbln4sax5zw19dqi6qgp9z";
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
