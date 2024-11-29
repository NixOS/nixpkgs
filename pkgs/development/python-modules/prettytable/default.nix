{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-lazy-fixtures,
  pytestCheckHook,
  pythonOlder,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "3.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "prettytable";
    rev = "refs/tags/${version}";
    hash = "sha256-LtphoD5gCMgWgDcFghinq9zjUD69XudEeGIToqqmVPs=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ wcwidth ];

  nativeCheckInputs = [
    pytest-lazy-fixtures
    pytestCheckHook
  ];

  pythonImportsCheck = [ "prettytable" ];

  meta = with lib; {
    description = "Display tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/jazzband/prettytable";
    changelog = "https://github.com/jazzband/prettytable/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
