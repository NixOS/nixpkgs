{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
=======
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "mwparserfromhell";
  version = "0.7.2";
<<<<<<< HEAD
  pyproject = true;

  src = fetchFromGitHub {
    owner = "earwig";
    repo = "mwparserfromhell";
    tag = "v${version}";
    hash = "sha256-yPj272bMh/pLapc7lDgP4+AnDBpE2FrDICRUxizIcSA=";
=======
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9Bkwcunqk7noj3cvYKAhJcBgLTKJDQu9yyde1YyLN2M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

<<<<<<< HEAD
  build-system = [
    setuptools
    setuptools-scm
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mwparserfromhell" ];

<<<<<<< HEAD
  meta = {
    description = "Parser for MediaWiki wikicode";
    homepage = "https://mwparserfromhell.readthedocs.io/";
    changelog = "https://github.com/earwig/mwparserfromhell/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
=======
  meta = with lib; {
    description = "MWParserFromHell is a parser for MediaWiki wikicode";
    homepage = "https://mwparserfromhell.readthedocs.io/";
    changelog = "https://github.com/earwig/mwparserfromhell/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ melling ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
