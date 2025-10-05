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
  version = "0.22.2";

  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ahocorasick_rs";
    hash = "sha256-h/J6ZCLb+U7A+f6ErAGI1KZrXHsvX23rFl8MXj25dpw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-uB3r6+Ewpi4dVke/TsCZltfc+ZABYLOLKuNxw+Jfu/M=";
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
