{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "regress";
  version = "2026.9.1";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-57VHOGv5e4KiPmJHEnJ0JJLAst5izw7pgkf9N8xC8Wk=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ljDpS7DhMRxSzY4VVOEUYZfw3dmDO5JkmjD1BSZLBks=";
  };

  meta = {
    description = "Python bindings to the Rust regress crate, exposing ECMA regular expressions";
    homepage = "https://github.com/Julian/regress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
}
