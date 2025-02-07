{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  cargo,
  rustc,
  libiconv,
}:

buildPythonPackage rec {
  pname = "pdoc-pyo3-sample-library";
  version = "1.0.11";
  pyproject = true;

  src = fetchPypi {
    pname = "pdoc_pyo3_sample_library";
    inherit version;
    hash = "sha256-ZGMo7WgymkSDQu8tc4rTfWNsIWO0AlDPG0OzpKRq3oA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-XqXkheK8OEzlLEbq09KMRFxrjJBnFaxvj4rIL2gmydA=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  pythonImportsCheck = [ "pdoc_pyo3_sample_library" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Sample PyO3 library used in pdoc tests";
    homepage = "https://github.com/mitmproxy/pdoc-pyo3-sample-library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pbsds ];
  };
}
