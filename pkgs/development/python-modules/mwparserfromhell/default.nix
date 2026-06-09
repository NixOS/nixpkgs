{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "mwparserfromhell";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "earwig";
    repo = "mwparserfromhell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yPj272bMh/pLapc7lDgP4+AnDBpE2FrDICRUxizIcSA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mwparserfromhell" ];

  meta = {
    description = "Parser for MediaWiki wikicode";
    homepage = "https://mwparserfromhell.readthedocs.io/";
    changelog = "https://github.com/earwig/mwparserfromhell/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
