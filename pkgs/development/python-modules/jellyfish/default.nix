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
  version = "1.0.0";

  disabled = !isPy3k;

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iBquNnGZm7B85QwnaW8pyn6ELz4SOswNtlJcmZmIG9Q=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-rust-dependencies";
    hash = "sha256-Grk+n4VCPjirafcRWWI51jHw/IFUYkBtbXY739j0MFI=";
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
