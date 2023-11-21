{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, rich
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rich-argparse";
  version = "1.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hamdanal";
    repo = "rich-argparse";
    rev = "refs/tags/v${version}";
    hash = "sha256-iQ8x8UM0zmb2qYUpSh6RSEaBMrDpwY0ZHaJ9GJqn4Hs=";
  };

  propagatedBuildInputs = [
    hatchling
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rich_argparse"
  ];

  meta = with lib; {
    description = "Format argparse help output using rich.";
    homepage = "https://github.com/hamdanal/rich-argparse";
    changelog = "https://github.com/hamdanal/rich-argparse/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
  };
}
