{ lib
, buildPythonPackage
, pythonOlder
, git
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "git-revise";
  version = "0.6.0";

  # Missing tests on PyPI
  src = fetchFromGitHub {
    owner = "mystor";
    repo = pname;
    rev = "v${version}";
    sha256 = "03v791yhips9cxz9hr07rhsgxfhwyqq17rzi7ayjhwvy65s4hzs9";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ git pytestCheckHook ];

  meta = with lib; {
    description = "Efficiently update, split, and rearrange git commits";
    homepage = "https://github.com/mystor/git-revise";
    changelog = "https://github.com/mystor/git-revise/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
  };
}
