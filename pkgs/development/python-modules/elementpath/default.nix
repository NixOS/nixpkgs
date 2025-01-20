{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "elementpath";
  version = "4.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    tag = "v${version}";
    hash = "sha256-lFUrY3LOSc2OROkzotGSW9N3h9dJA4EnCvLNU41BPA0=";
  };

  build-system = [ setuptools ];

  # avoid circular dependency with xmlschema which directly depends on this
  doCheck = false;

  pythonImportsCheck = [ "elementpath" ];

  meta = with lib; {
    description = "XPath 1.0/2.0 parsers and selectors for ElementTree and lxml";
    homepage = "https://github.com/sissaschool/elementpath";
    changelog = "https://github.com/sissaschool/elementpath/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
