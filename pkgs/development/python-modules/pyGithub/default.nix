{ stdenv, fetchFromGitHub
, cacert
, buildPythonPackage, pyjwt }:

buildPythonPackage rec {
  name = "PyGithub-${version}";
  version = "1.35";

  src = fetchFromGitHub {
    owner = "PyGithub";
    repo = "PyGithub";
    rev = version;
    sha256 = "0qp4jiizpnhzbp1dv5a2ap3wqmqbvbh0p9i3j4ld8xz80nyml5d7";
  };

  postPatch = ''
    # requires network
    echo "" > github/tests/Issue142.py
  '';

  propagatedBuildInputs = [ pyjwt ];

  meta = with stdenv.lib; {
    homepage = https://github.com/PyGithub/PyGithub;
    description = "A Python (2 and 3) library to access the GitHub API v3";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jhhuh ];
  };
}
