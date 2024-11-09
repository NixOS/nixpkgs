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
  version = "0.17.1";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = pname;
    repo = "radish";
    rev = "refs/tags/v${version}";
    hash = "sha256-9Wt+W7PWUVijzAeZMvcOl/Na60OCCGJJqxh2UaAxAcM=";
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
    changelog = "https://github.com/radish-bdd/radish/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      kalbasit
      l33tname
    ];
  };
}
