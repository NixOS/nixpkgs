{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "add-trailing-comma";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/dA3OwBBMjykSYaIbvhJZj9Z8/0+mfL5pW4GqgMgops=";
  };

  propagatedBuildInputs = [
    tokenize-rt
  ];

  pythonImportsCheck = [
    "add_trailing_comma"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A tool (and pre-commit hook) to automatically add trailing commas to calls and literals";
    homepage = "https://github.com/asottile/add-trailing-comma";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
