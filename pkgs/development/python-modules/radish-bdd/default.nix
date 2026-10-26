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
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  tag-expressions,
}:

buildPythonPackage (finalAttrs: {
  pname = "radish-bdd";
  version = "0.18.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = finalAttrs.pname;
    repo = "radish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pnZ/vqjMd1Q/wF1W6joYrIulZSXAzS2G3E5Ke5VSAQg=";
  };

  propagatedBuildInputs = [
    colorful
    docopt
    humanize
    lxml
    parse-type
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
    changelog = "https://github.com/radish-bdd/radish/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kalbasit
      l33tname
    ];
  };
})
