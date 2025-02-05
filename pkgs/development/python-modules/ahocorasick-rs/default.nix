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
  version = "0.22.0";

  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "ahocorasick_rs";
    hash = "sha256-lzRwODlJlymMSih3CqNIeR+HrUbgVhroM1JuHFfW848=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Oslf85uI3pO9br7s1J9Y9I/UZ5KDOvJZ/30BMudVBZ0=";
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

  pythonImportsCheck = [ "ahocorasick_rs" ];

  meta = with lib; {
    description = "Fast Aho-Corasick algorithm for Python";
    homepage = "https://github.com/G-Research/ahocorasick_rs/";
    changelog = "https://github.com/G-Research/ahocorasick_rs/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ erictapen ];
  };

}
