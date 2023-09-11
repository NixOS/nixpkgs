{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, rich
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rich-argparse";
  version = "1.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hamdanal";
    repo = "rich-argparse";
    rev = "v${version}";
    hash = "sha256-WAqFhH9gUwDZuORJ++fKjCmaCurdYpep3WPq68tWJ4U=";
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
