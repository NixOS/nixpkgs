{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "airportsdata";
  version = "20250706";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mborsetti";
    repo = "airportsdata";
    tag = "v${version}";
    hash = "sha256-DINR1r+Gn88XB4EddNg04CNSifYlETRW0ptCX5w2ndM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "airportsdata" ];

  meta = {
    description = "Extensive database of location and timezone data for nearly every operational airport";
    homepage = "https://github.com/mborsetti/airportsdata/";
    changelog = "https://github.com/mborsetti/airportsdata/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danieldk ];
  };
}
