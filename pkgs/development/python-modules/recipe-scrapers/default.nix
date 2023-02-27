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
  version = "14.32.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hhursev";
    repo = "recipe-scrapers";
    rev = "refs/tags/${version}";
    hash = "sha256-6iUagD1PTTAraBHOWLjHiLFFsImO30w84p+6IcIv52c=";
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
