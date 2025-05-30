{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  meson,
  rustc,
  cargo,
  ninja,
  xdg-desktop-portal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-shana";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "xdg-desktop-portal-shana";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9uie6VFyi7sO8DbthUTgpEc68MvvLA+bUwyV/DSpKkE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-f9kfCoH0YHVzzZC4rChJgz0yQqVVAYR7Gpa6HuXhQZY=";
  };

  nativeBuildInputs = [
    meson
    rustc
    rustPlatform.cargoSetupHook
    cargo
    ninja
  ];

  buildInputs = [
    xdg-desktop-portal
  ];

  meta = {
    description = "Filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      samuelefacenda
      Rishik-Y
    ];
  };
})
