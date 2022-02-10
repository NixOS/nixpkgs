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
  version = "0.13.4";

  # Pypi package does not have necessary test fixtures.
  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    rev = "v${version}";
    sha256 = "1slfgh61648i009qj8156qipy21a6zm8qzjk00kbm5kk5z9jfryi";
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
