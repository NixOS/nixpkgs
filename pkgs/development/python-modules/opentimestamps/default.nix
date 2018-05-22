{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, bitcoinlib, GitPython, pysha3 }:

buildPythonPackage rec {
  pname = "opentimestamps";
  version = "0.3.0";
  disabled = (!isPy3k);

  # We can't use the pypi source because it doesn't include README.md which is
  # needed in setup.py
  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "python-opentimestamps";
    rev = "python-opentimestamps-v${version}";
    sha256 = "1i843mbz4h9vqc3y2x09ix6bv9wc0gzq36zhbnmf5by08iaiydks";
  };

  # Remove a failing test which expects the test source file to reside in the
  # project's Git repo
  patchPhase = ''
    rm opentimestamps/tests/core/test_git.py
  '';

  propagatedBuildInputs = [ bitcoinlib GitPython pysha3 ];

  meta = {
    description = "Create and verify OpenTimestamps proofs";
    homepage = https://github.com/opentimestamps/python-opentimestamps;
    license = lib.licenses.lgpl3;
  };
}
