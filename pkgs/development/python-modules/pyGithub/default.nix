{ stdenv, fetchFromGitHub
, buildPythonPackage, python-jose, pyjwt }:

buildPythonPackage rec {
  pname = "PyGithub";
  version = "1.36";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = "v${version}";
    sha256 = "0yb74f9hg2vdsy766m850hfb1ss17lbgcdvvklm4qf72w12nxc5w";
  };

  postPatch = ''
    # requires network
    echo "" > github/tests/Issue142.py
  '';
  propagatedBuildInputs = [ python-jose pyjwt ];
  meta = with stdenv.lib; {
    homepage = https://github.com/PyGithub/PyGithub;
    description = "A Python (2 and 3) library to access the GitHub API v3";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jhhuh ];
  };
}
