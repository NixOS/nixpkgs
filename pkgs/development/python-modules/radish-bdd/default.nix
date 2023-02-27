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
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    rev = "refs/tags/v${version}";
    hash = "sha256-SEW10ka0aQAXtW2UNCVJHMVhhZ9JTTj4IbskL87/Dn4=";
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
    homepage = "http://radish-bdd.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
