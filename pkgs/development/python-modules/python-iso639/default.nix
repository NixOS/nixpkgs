{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-iso639";
  version = "2025.2.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jacksonllee";
    repo = "iso639";
    tag = "v${version}";
    hash = "sha256-CVLyeXA0FXLCthNO3SLgTvxi4sJI5fPhuqEbnDb4L/s=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "iso639" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jacksonllee/iso639/blob/${src.tag}/CHANGELOG.md";
    description = "ISO 639 language codes, names, and other associated information";
    homepage = "https://github.com/jacksonllee/iso639";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
