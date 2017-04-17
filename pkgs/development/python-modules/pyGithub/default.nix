{ stdenv, fetchFromGitHub
, cacert
, buildPythonPackage, python-jose }:

buildPythonPackage rec {
  name = "PyGithub-${version}";
  version = "1.32";

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "15dr9ja63zdxax9lg6q2kcakqa82dpffyhgpjr13wq3sfkcy5pdw";
  };

  postPatch = ''
    # requires network
    echo "" > github/tests/Issue142.py
  '';
  propagatedBuildInputs = [ python-jose ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/PyGithub/PyGithub";
    description = "A Python (2 and 3) library to access the GitHub API v3";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jhhuh ];
  };
}
