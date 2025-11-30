{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
  pyahocorasick,
  hypothesis,
  typing-extensions,
  pytest-benchmark,
}:

buildPythonPackage rec {
  pname = "ahocorasick-rs";
  version = "1.0.3";

  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ahocorasick_rs";
    hash = "sha256-V503Bwp8Idqc2ZiLn7RxKXJztgy0EmWG1tzZn6r8XKU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-RfgjO0qffiAZynQ/xChd81L8S0sqTGdWvpHPrz3bKlQ=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  dependencies = lib.optionals (pythonOlder "3.12") [ typing-extensions ];

  nativeCheckInputs = [
    pytest-benchmark
    pytestCheckHook
    pyahocorasick
    hypothesis
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "ahocorasick_rs" ];

  meta = with lib; {
    description = "Fast Aho-Corasick algorithm for Python";
    homepage = "https://github.com/G-Research/ahocorasick_rs/";
    changelog = "https://github.com/G-Research/ahocorasick_rs/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ erictapen ];
  };

}
