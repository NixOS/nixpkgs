{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildPythonPackage,
  uvloop,
  click,
  libiconv,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "granian";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    rev = "v${version}";
    hash = "sha256-YQ9+PcKXtSc+wdvhgDfSAfcv/y53oqcrPCEI9dDKFa0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-XJ61+u5aGQis6YkfASD+WJHEKDBL+2ImqCAuQmm3A/g=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = [
    libiconv
  ];

  dependencies = [
    uvloop
    click
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust HTTP server for Python ASGI/WSGI/RSGI applications";
    homepage = "https://github.com/emmett-framework/granian";
    license = lib.licenses.bsd3;
    mainProgram = "granian";
    maintainers = with lib.maintainers; [ lucastso10 ];
    platforms = lib.platforms.unix;
  };
}
