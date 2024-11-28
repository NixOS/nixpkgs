{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  beautifulsoup4,
  extruct,
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
  version = "15.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hhursev";
    repo = "recipe-scrapers";
    rev = "refs/tags/${version}";
    hash = "sha256-2rwy7tfTKaUmPJv59WMVGAOUP+vGWquJbF/3BbS3kkA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    extruct
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
