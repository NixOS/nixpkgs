{
  lib,
  stdenv,
  fetchgit,
  cargo,
  perl,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vodozemac-bindings-cpp";
  version = "0.2.1";

  src = fetchgit {
    url = "https://iron.lily-is.land/diffusion/VB/vodozemac-bindings.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j6s+O3s6xSIZ+6aWI3itVwL4OU4qhoXos1R2NMBrJdo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-RyZGR6VxWH98ujydPFbuzKZil+1pxk4qD6EuaCnN1Y8=";
  };

  makeFlags = [
    "-C"
    "cpp"
    "PREFIX=${placeholder "out"}"
  ];

  nativeBuildInputs = [
    cargo
    perl
    rustPlatform.cargoSetupHook
  ];

  meta = {
    description = "C++ bindings for the vodozemac cryptographic library.";
    homepage = "https://iron.lily-is.land/diffusion/VB/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
