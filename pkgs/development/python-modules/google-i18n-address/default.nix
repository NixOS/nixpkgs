{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-i18n-address";
  version = "3.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "google-i18n-address";
    rev = "refs/tags/${version}";
    hash = "sha256-dW/1wwnFDjYpym1ZaSZ7mOLpkHxsvuAHC8zBRekxWaw=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "i18naddress" ];

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    mainProgram = "update-validation-files";
    homepage = "https://github.com/mirumee/google-i18n-address";
    changelog = "https://github.com/mirumee/google-i18n-address/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
