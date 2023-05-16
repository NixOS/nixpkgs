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
<<<<<<< HEAD
  version = "0.16.1";
=======
  version = "0.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-fzxjDMmz5NMFRTQchlCOx2igqmhS6Zg0IU5HFO5a/0k=";
=======
    hash = "sha256-SEW10ka0aQAXtW2UNCVJHMVhhZ9JTTj4IbskL87/Dn4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
