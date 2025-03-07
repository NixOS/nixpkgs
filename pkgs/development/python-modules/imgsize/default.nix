{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "imgsize";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ojii";
    repo = "imgsize";
    tag = version;
    sha256 = "sha256-i0YCt5jTnDAxnaxKSTloWrQn27yLAvZnghZlCgwZh0Q=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-V/24lqMVTCw+9YMZQ7ABXnA0tzX8IQNxHtmNkHRbXbU=";
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
