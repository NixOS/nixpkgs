{ lib
, buildPythonPackage
, click
, colorful
, docopt
, fetchFromGitHub
, freezegun
, humanize
, lark
, lxml
, parse-type
, pysingleton
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
, tag-expressions
}:

buildPythonPackage rec {
  pname = "radish-bdd";
  version = "0.17.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    rev = "refs/tags/v${version}";
    hash = "sha256-9Wt+W7PWUVijzAeZMvcOl/Na60OCCGJJqxh2UaAxAcM=";
  };

  propagatedBuildInputs = [
    click
    colorful
    docopt
    humanize
    lark
    lxml
    parse-type
    pysingleton
    tag-expressions
  ];

  nativeCheckInputs = [
    freezegun
    pytest-mock
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [
    "radish"
  ];

  disabledTests = [
    "test_main_cli_calls"
  ];

  meta = with lib; {
    description = "Behaviour-Driven-Development tool for python";
    homepage = "https://radish-bdd.github.io/";
    changelog = "https://github.com/radish-bdd/radish/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
