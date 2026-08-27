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
  nixosTests,
}:

buildPythonPackage (finalAttrs: {
  pname = "recipe-scrapers";
  version = "15.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhursev";
    repo = "recipe-scrapers";
    tag = finalAttrs.version;
    hash = "sha256-ME5/I2qnuTalgsiI34hQ45AyFqfol6dfLnc/S9vJ6tc=";
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

  meta = {
    description = "Python package for scraping recipes data";
    homepage = "https://github.com/hhursev/recipe-scrapers";
    changelog = "https://github.com/hhursev/recipe-scrapers/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
