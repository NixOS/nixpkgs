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
  version = "2025.3.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x7qNFuUFPXc/SIZkwQGAmJ538kIotEbsmF7XbjrAWQE=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-B652Bfanw51e+U6rHukWtfdr7bjoWDUx/nUczDwyzZk=";
  };

  meta = with lib; {
    description = "Python bindings to the Rust regress crate, exposing ECMA regular expressions";
    homepage = "https://github.com/Julian/regress";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
