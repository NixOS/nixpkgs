{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, blspy
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clvm";
  version = "0.9.7";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm";
    rev = version;
    hash = "sha256-kTmuiy0IbTGjDokZjxp3p8lr/0uVxG/0pRN2hETLBtA=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # give a hint to setuptools-scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = [
    blspy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # all tests in this file have a circular dependency on clvm-tools
    "tests/cmds_test.py"
  ];

  pythonImportsCheck = [
    "clvm"
  ];

  meta = with lib; {
    description = "Chia Lisp virtual machine";
    homepage = "https://www.chia.net/";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
