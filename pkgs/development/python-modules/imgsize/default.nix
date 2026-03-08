{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "imgsize";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ojii";
    repo = "imgsize";
    tag = version;
    sha256 = "sha256-Cm6dywl9QOtF8qZ3L/XHCeNf3mU1ki5l8RUpWQilBPw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-8vSBsnNqvHlbSj7m09U9fqBMRHnC2qtpMtWp2KYGA08=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # remove useless dev setup in conftest.py
  preCheck = ''
    substituteInPlace python-tests/conftest.py \
      --replace-fail 'assert sys.prefix != sys.base_prefix, "must be in virtualenv"' "" \
      --replace-fail 'check_call(' "# "
  '';

  meta = {
    description = "Pure Python image size library";
    homepage = "https://github.com/ojii/imgsize";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ twey ];
  };
}
