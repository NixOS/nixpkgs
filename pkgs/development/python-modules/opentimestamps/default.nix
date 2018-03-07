{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, bitcoinlib, GitPython, pysha3 }:

buildPythonPackage rec {
  name = "opentimestamps-${version}";
  version = "0.2.1";
  disabled = (!isPy3k);

  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "python-opentimestamps";
    rev = "python-opentimestamps-v0.2.1";
    sha256 = "1cilv1ls9mdqk8zriqfkz7xcl8i1ncm0f89n4c8k4s82kf5y56rm";
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
