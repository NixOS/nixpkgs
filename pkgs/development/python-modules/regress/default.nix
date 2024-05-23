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
  version = "0.4.5";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tCrFBjkK6obzaYkYiJ3WQ5yi3KkC86/cbXCSnRRGZu8=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-wHObfXWgcbSYxk5d17s44+1qIGYD/Ygefxp+el0fsEc=";
  };

  meta = with lib; {
    description = "Python bindings to the Rust regress crate, exposing ECMA regular expressions.";
    homepage = "https://github.com/Julian/regress";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
