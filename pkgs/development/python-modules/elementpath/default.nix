{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "elementpath";
  version = "4.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "refs/tags/v${version}";
    hash = "sha256-5K2xcnTo3/A6/pCxQn5qZqni7C64p/yNAWWJlhQeKe4=";
  };

  # avoid circular dependency with xmlschema which directly depends on this
  doCheck = false;

  pythonImportsCheck = [
    "elementpath"
  ];

  meta = with lib; {
    description = "XPath 1.0/2.0 parsers and selectors for ElementTree and lxml";
    homepage = "https://github.com/sissaschool/elementpath";
    changelog = "https://github.com/sissaschool/elementpath/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
