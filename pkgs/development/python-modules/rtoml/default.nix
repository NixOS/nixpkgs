{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libiconv,
  dirty-equals,
  pytest-benchmark,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "rtoml";
  version = "0.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1movtKMQkQ6PEpKpSkK0Oy4AV0ee7XrS0P9m6QwZTaM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-BWcOIZMl4yHxxKxCn6Qh69MlMdz3REp3izN0A1eFX3o=";
  };

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = [ libiconv ];

  pythonImportsCheck = [ "rtoml" ];

  nativeCheckInputs = [
    dirty-equals
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  disabledTests = [
    # TypeError: loads() got an unexpected keyword argument 'name'
    "test_load_data_toml"
  ];

  preCheck = ''
    rm -rf rtoml
  '';

  meta = with lib; {
    description = "Rust based TOML library for Python";
    homepage = "https://github.com/samuelcolvin/rtoml";
    license = licenses.mit;
    maintainers = with maintainers; [ evils ];
  };
}
