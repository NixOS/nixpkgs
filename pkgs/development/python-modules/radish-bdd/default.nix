{ lib
, buildPythonPackage
, click
, colorful
, docopt
, fetchFromGitHub
, freezegun
, humanize
, lark-parser
, parse-type
, pysingleton
, pytestCheckHook
, pyyaml
, tag-expressions
, lxml
, pytest-mock
}:

buildPythonPackage rec {
  pname = "radish-bdd";
  version = "0.13.2";

  # Pypi package does not have necessary test fixtures.
  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    rev = "v${version}";
    sha256 = "1k7l0j8w221pa6k990x4rfm7km4asx5zy4zpzvh029lb9nw2pp8b";
  };

  propagatedBuildInputs = [
    lark-parser
    click
    colorful
    tag-expressions
    parse-type
    humanize
    pyyaml
    docopt
    pysingleton
  ];

  checkInputs = [ freezegun lxml pytestCheckHook pytest-mock ];
  disabledTests = [ "test_main_cli_calls" ];

  meta = with lib; {
    description = "Behaviour-Driven-Development tool for python";
    homepage = "http://radish-bdd.io";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
