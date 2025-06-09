{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "elementpath";
  version = "5.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    tag = "v${version}";
    hash = "sha256-t0vIa30whaP/BF3NzTkZVvHAlVd9ioXZb5rhBsLJq4U=";
  };

  build-system = [ setuptools ];

  # avoid circular dependency with xmlschema which directly depends on this
  doCheck = false;

  pythonImportsCheck = [ "elementpath" ];

  meta = with lib; {
    description = "XPath 1.0/2.0 parsers and selectors for ElementTree and lxml";
    homepage = "https://github.com/sissaschool/elementpath";
    changelog = "https://github.com/sissaschool/elementpath/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
