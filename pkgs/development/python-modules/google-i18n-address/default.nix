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
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "google-i18n-address";
    rev = "refs/tags/${version}";
    hash = "sha256-7RqS/+6zInlhWydJwp4xf2uGpfmSdiSwvJugpL8Mlpk=";
  };

  build-system = [ hatchling ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "i18naddress" ];

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    homepage = "https://github.com/mirumee/google-i18n-address";
    changelog = "https://github.com/mirumee/google-i18n-address/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "update-validation-files";
  };
}
