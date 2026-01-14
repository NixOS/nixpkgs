{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  perl,
  rustPlatform,
  rustc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vodozemac-bindings-cpp";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "lily-is.land";
    owner = "kazv";
    repo = "vodozemac-bindings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DOc5GxMgpecJeQtkDSwvGD+bOyCZ8XRQ/uC/RAnKQv4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-puMPW87zCTJhhtO6HXUa2xl7edAk546xT1x1rpyDJWU=";
  };

  nativeBuildInputs = [
    cargo
    perl
    rustPlatform.cargoSetupHook
    rustc
  ];

  makeFlags = [ "-Ccpp" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "C++ bindings for the vodozemac cryptographic library";
    homepage = "https://lily-is.land/kazv/vodozemac-bindings";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
