{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytado";
  version = "0.17.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    rev = "refs/tags/${version}";
    hash = "sha256-KcYxUKQuO7TLS4YPg2mrBjP+DMnvZeJokGzwmeM/CvE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "PyTado" ];

  meta = with lib; {
    description = "Python binding for Tado web API";
    mainProgram = "pytado";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
