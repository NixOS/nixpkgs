{ lib
, fetchFromGitHub
, buildPythonPackage
, doit
, configclass
, mergedict
, pytestCheckHook
, hunspell
, hunspellDicts
}:

buildPythonPackage rec {
  pname = "doit-py";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "pydoit";
    repo = pname;
    rev = version;
    sha256 = "sha256-DBl6/no04ZGRHHmN9gkEtBmAMgmyZWcfPCcFz0uxAv4=";
  };

  propagatedBuildInputs = [
    configclass
    doit
    mergedict
  ];

  checkInputs = [
    hunspell
    hunspellDicts.en_US
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Disable linting checks
    "tests/test_pyflakes.py"
  ];

  pythonImportsCheck = [ "doitpy" ];

  meta = with lib; {
    description = "doit tasks for python stuff";
    homepage = "http://pythonhosted.org/doit-py";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
