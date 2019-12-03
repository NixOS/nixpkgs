{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, bitcoinlib, GitPython, pysha3, git }:

buildPythonPackage rec {
  pname = "opentimestamps";
  version = "0.4.1";
  disabled = (!isPy3k);

  # We can't use the pypi source because it doesn't include README.md which is
  # needed in setup.py
  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "python-opentimestamps";
    rev = "python-opentimestamps-v${version}";
    sha256 = "0c45ij8absfgwizq6dfgg81siq3y8605sgg184vazp292w8nqmqr";
  };

  # Remove a failing test which expects the test source file to reside in the
  # project's Git repo
  postPatch = ''
    rm opentimestamps/tests/core/test_git.py
  '';

  checkInputs = [ git ];
  propagatedBuildInputs = [ bitcoinlib GitPython pysha3 ];

  meta = {
    description = "Create and verify OpenTimestamps proofs";
    homepage = https://github.com/opentimestamps/python-opentimestamps;
    license = lib.licenses.lgpl3;
  };
}
