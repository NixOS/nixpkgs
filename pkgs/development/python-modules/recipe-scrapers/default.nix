{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  extruct,
  isodate,
  language-tags,
  regex,
  requests,
  pytestCheckHook,
  responses,
  setuptools,
  pythonOlder,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "recipe-scrapers";
  version = "15.3.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hhursev";
    repo = "recipe-scrapers";
    tag = version;
    hash = "sha256-rIQ6OfxsVczidLYVvXtkfpBk/KGLgDo+h4kqKXXSD80=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    extruct
    isodate
    language-tags
    regex
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # Fixture is broken
    "test_instructions"
  ];

  pythonImportsCheck = [ "recipe_scrapers" ];

  passthru = {
    tests = {
      inherit (nixosTests) mealie tandoor-recipes;
    };
  };

  meta = with lib; {
    description = "Python package for scraping recipes data";
    homepage = "https://github.com/hhursev/recipe-scrapers";
    changelog = "https://github.com/hhursev/recipe-scrapers/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
