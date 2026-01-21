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
  pyyaml,
  tag-expressions,
}:

buildPythonPackage rec {
  pname = "radish-bdd";
  version = "0.18.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    tag = "v${version}";
    hash = "sha256-UjJz9ysejz5DBewMwoVof1+JU8tbGbBa3z1quuN1TWg=";
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

  meta = {
    description = "Behaviour-Driven-Development tool for python";
    homepage = "https://radish-bdd.github.io/";
    changelog = "https://github.com/radish-bdd/radish/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kalbasit
      l33tname
    ];
  };
}
