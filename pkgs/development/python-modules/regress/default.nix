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
  version = "2025.10.1";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3MCorwzbw9bg1HJfETM10KX/u6hq48oY0rWzUsXyyO0=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-DOnKFVg+5cIv0T3mKzF8O9jj5+ZenQrLjTltfd+Tm9U=";
  };

  meta = {
    description = "Python bindings to the Rust regress crate, exposing ECMA regular expressions";
    homepage = "https://github.com/Julian/regress";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
}
