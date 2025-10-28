{
  buildPythonPackage,
  fetchFromGitHub,
  htmltools,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "faicons";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "py-faicons";
    tag = "v${version}";
    hash = "sha256-okkZ8anirjcZcZeB3XjvNJpiYQEau+o6dmCGqFBD8XY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    htmltools
  ];

  pythonImportsCheck = [ "faicons" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/posit-dev/py-faicons/blob/${src.tag}/CHANGELOG.md";
    description = "Interface to Font-Awesome for use in Shiny";
    homepage = "https://github.com/posit-dev/py-faicons";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
