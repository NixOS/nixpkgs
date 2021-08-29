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
  version = "0.9.6";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm";
    rev = version;
    sha256 = "sha256-XBQEilDFhx0kT9bEMD4jX+SDk3cAC1BUCWhbtpgrLcA=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # give a hint to setuptools_scm on package version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  propagatedBuildInputs = [
    blspy
  ];

  checkInputs = [
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
