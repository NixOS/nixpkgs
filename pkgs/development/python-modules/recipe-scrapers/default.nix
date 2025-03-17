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
  version = "15.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hhursev";
    repo = "recipe-scrapers";
    tag = version;
    hash = "sha256-s/ocJi7NidebFkd724p/k7njOzELsdh7n9nQXaeVXV8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    extruct
    isodate
    language-tags
    regex
  ];

  optional-dependencies = {
    online = [ requests ];
  };

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
