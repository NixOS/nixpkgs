{ lib
, bitcoinlib
, buildPythonPackage
, fetchFromGitHub
, git
, GitPython
, pysha3
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "opentimestamps";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "python-opentimestamps";
    rev = "python-opentimestamps-v${version}";
    hash = "sha256-RRCAxDYWySmnG1sEQWurUDQsu+vPx9Npbr6BaoNGm1U=";
  };

  propagatedBuildInputs = [
    bitcoinlib
    GitPython
    pysha3
  ];

  checkInputs = [
    git
    pytestCheckHook
  ];

  # Remove a failing test which expects the test source file to reside in the
  # project's Git repo
  postPatch = ''
    rm opentimestamps/tests/core/test_git.py
  '';

  pythonImportsCheck = [
    "opentimestamps"
  ];

  meta = with lib; {
    description = "Create and verify OpenTimestamps proofs";
    homepage = "https://github.com/opentimestamps/python-opentimestamps";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
