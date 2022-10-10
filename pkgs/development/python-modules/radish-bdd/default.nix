{ lib
, buildPythonPackage
, click
, colorful
, docopt
, fetchFromGitHub
, freezegun
, humanize
, lark
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
  version = "0.14.0";

  # Pypi package does not have necessary test fixtures.
  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7C8XgGlpNVUONSfg9DsIS8Awpy6iDzFOLAFs1xpfHXI=";
  };

  propagatedBuildInputs = [
    lark
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
