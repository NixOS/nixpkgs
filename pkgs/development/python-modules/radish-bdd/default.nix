{
  lib,
  buildPythonPackage,
  colorful,
  docopt,
  fetchFromGitHub,
  freezegun,
  humanize,
  lxml,
  parse-type,
  pysingleton,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  tag-expressions,
}:

buildPythonPackage rec {
  pname = "radish-bdd";
  version = "0.18.2";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    tag = "v${version}";
    hash = "sha256-SSrEKGs4q4rcnQM03/gc0/vEb7gmTmpfgeNp3e+Hyvg=";
  };

  propagatedBuildInputs = [
    colorful
    docopt
    humanize
    lxml
    parse-type
    pysingleton
    pyyaml
    tag-expressions
  ];

  nativeCheckInputs = [
    freezegun
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "radish" ];

  meta = with lib; {
    description = "Behaviour-Driven-Development tool for python";
    homepage = "https://radish-bdd.github.io/";
    changelog = "https://github.com/radish-bdd/radish/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      kalbasit
      l33tname
    ];
  };
}
