{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, extruct
, language-tags
, regex
, requests
, pytestCheckHook
, responses
, setuptools
}:

buildPythonPackage rec {
  pname = "recipe-scrapers";
<<<<<<< HEAD
  version = "14.43.0";
=======
  version = "14.36.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hhursev";
    repo = "recipe-scrapers";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-ik/ADmu6yGY7xWXCAn0kcWJphANIIwM8QKWjm9xoVYQ=";
=======
    hash = "sha256-JadtlJMxRib8FpNC4QGYXfUEJGyB1aniDbsbsBYU3no=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

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

  disabledTestPaths = [
    # This is not actual code, just some pre-written boiler-plate template
    "templates/test_scraper.py"
  ];

  pythonImportsCheck = [ "recipe_scrapers" ];

  meta = with lib; {
    description = "Python package for scraping recipes data ";
    homepage = "https://github.com/hhursev/recipe-scrapers";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
