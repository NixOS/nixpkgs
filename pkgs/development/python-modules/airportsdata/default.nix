{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "airportsdata";
  version = "20260905";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mborsetti";
    repo = "airportsdata";
    tag = "v${version}";
    hash = "sha256-UBs9/uC3tASdcnKhSlNPSb7oA8KpyQpaO0jLr59eokI=";
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
