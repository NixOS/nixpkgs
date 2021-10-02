{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, colorful
, tomlkit
, git
, requests
}:

buildPythonPackage rec {
  pname = "pontos";
  version = "21.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pgvpg5sjmd9p1i9lm39k4r5qsz158wfgwfa56rx0p8xqf00h1xp";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    colorful
    tomlkit
    requests
  ];

  checkInputs = [
    git
    pytestCheckHook
  ];

  disabledTests = [
    # Signing fails
    "test_find_no_signing_key"
    "test_find_signing_key"
    "test_find_unreleased_information"
  ];

  pythonImportsCheck = [ "pontos" ];

  meta = with lib; {
    description = "Collection of Python utilities, tools, classes and functions";
    homepage = "https://github.com/greenbone/pontos";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
