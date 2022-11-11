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
}:

buildPythonPackage rec {
  pname = "recipe-scrapers";
  version = "14.14.0";

  src = fetchFromGitHub {
    owner = "hhursev";
    repo = "recipe-scrapers";
    rev = version;
    sha256 = "sha256-3qrjNd1jX4JP3qG9YX8MQqwPh8cvfkZa1tEk0uCwego=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    extruct
    language-tags
    regex
    requests
  ];

  checkInputs = [
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
