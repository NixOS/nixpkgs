{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymeteoclimatic";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "adrianmo";
    repo = "pymeteoclimatic";
    rev = "refs/tags/${version}";
    hash = "sha256-rP0+OYDnQ4GuoV7DzR6jtgH6ilTMLjdaEFJcz3L0GYQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "meteoclimatic" ];

  meta = with lib; {
    description = "Python wrapper around the Meteoclimatic service";
    homepage = "https://github.com/adrianmo/pymeteoclimatic";
    changelog = "https://github.com/adrianmo/pymeteoclimatic/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
