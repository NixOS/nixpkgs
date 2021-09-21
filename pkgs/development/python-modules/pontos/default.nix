{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry
, pytestCheckHook
, pythonOlder
, colorful
, tomlkit
, git
, requests
}:

buildPythonPackage rec {
  pname = "pontos";
  version = "21.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oNE15BGLKStIyMkuSyypZKFxa73Qsgnf+SMz/rq/gGg=";
  };

  nativeBuildInputs = [
    poetry
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
