{
  lib,
  python-bitcoinlib,
  buildPythonPackage,
  fetchFromGitHub,
  gitpython,
  pycryptodomex,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "opentimestamps";
  version = "0.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "python-opentimestamps";
    rev = "python-opentimestamps-v${version}";
    hash = "sha256-clG/5NAPmmmoj4b3LdVwl58DHg1EFMIMu+erx+GT+NE=";
  };

  propagatedBuildInputs = [
    python-bitcoinlib
    gitpython
    pycryptodomex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Remove a failing test which expects the test source file to reside in the
  # project's Git repo
  postPatch = ''
    rm opentimestamps/tests/core/test_git.py
  '';

  pythonImportsCheck = [ "opentimestamps" ];

  meta = with lib; {
    description = "Create and verify OpenTimestamps proofs";
    homepage = "https://github.com/opentimestamps/python-opentimestamps";
    changelog = "https://github.com/opentimestamps/python-opentimestamps/releases/tag/python-opentimestamps-v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
