{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "elementpath";
  version = "2.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "refs/tags/v${version}";
    hash = "sha256-+NCsWPt5yMXe+GR9nEBU7byYhKrH/6xghQioj9AOGm4=";
  };

  # avoid circular dependency with xmlschema which directly depends on this
  doCheck = false;

  pythonImportsCheck = [
    "elementpath"
  ];

  meta = with lib; {
    description = "XPath 1.0/2.0 parsers and selectors for ElementTree and lxml";
    homepage = "https://github.com/sissaschool/elementpath";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
