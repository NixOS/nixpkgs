{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
  pyahocorasick,
  hypothesis,
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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-CIt/ChNcoqKln6PgeTGp9pfmIWlJj+c5SCPtBhsnT6U=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

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
