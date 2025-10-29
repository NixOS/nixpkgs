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

  format = "pyproject";

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

  meta = with lib; {
    description = "Python bindings to the Rust regress crate, exposing ECMA regular expressions";
    homepage = "https://github.com/Julian/regress";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
