{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "iso639";
  version = "2024.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jacksonllee";
    repo = "iso639";
    rev = "v${version}";
    hash = "sha256-ANZV/Q+2V5m5/7/1qkw2gRCaimRMlvXhOrewe5wmP1s=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "iso639" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "ISO 639 language codes";
    homepage = "https://github.com/jacksonllee/iso639";
    changelog = "https://github.com/jacksonllee/iso639/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
