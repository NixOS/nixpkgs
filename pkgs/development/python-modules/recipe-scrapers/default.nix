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
  version = "14.26.0";

  src = fetchFromGitHub {
    owner = "hhursev";
    repo = "recipe-scrapers";
    rev = "refs/tags/${version}";
    sha256 = "sha256-U7A9HmkXPcuYEsY/uGUVh3LYHDYhV/uizELh1/vXG+U=";
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
