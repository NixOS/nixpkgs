{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pytest,
  unicodecsv,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "jellyfish";
  version = "1.0.4";

  disabled = !isPy3k;

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cqq7O+3VE83SBxIkL9URc7WZcsCxRregucbzLxZWKT8=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-rust-dependencies";
    hash = "sha256-HtzgxTO6tbN/tohaiTm9B9jrFYGTt1Szo9qRzpcy8BA=";
  };

  nativeCheckInputs = [
    pytest
    unicodecsv
  ];

  meta = {
    homepage = "https://github.com/sunlightlabs/jellyfish";
    description = "Approximate and phonetic matching of strings";
    maintainers = with lib.maintainers; [ koral ];
  };
}
