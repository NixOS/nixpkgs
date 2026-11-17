{
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  cmake,
  gitMinimal,
  python3,
  openxr-loader,
  libxkbcommon,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xr-chaperone";
  version = "0-unstable-2026-05-20";

  src = fetchFromGitHub {
    owner = "FrostyCoolSlug";
    repo = "xr-chaperone";
    rev = "a0351bd00f208e9f7c7917d413de2accbf9208eb";
    hash = "sha256-d3h3xBxEMza4MmmpDiUCHeaC6MVg1yUwZjMCwBEyLos=";
  };

  cargoHash = "sha256-9uEosKwKGNruwxp/uslXj0WAFowY4Tu2CikWa2JiOf4=";

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    gitMinimal
    python3
  ];

  buildInputs = [ openxr-loader ];

  runtimeDependencies = [ libxkbcommon ];

  postInstall = ''
    install -m 444 -D resources/xr-chaperone.desktop $out/share/applications/xr-chaperone.desktop
    install -m 444 -D resources/xr-chaperone.png $out/share/icons/hicolor/256x256/apps/xr-chaperone.png
    install -m 444 -D resources/xr-chaperone.svg $out/share/icons/hicolor/scalable/apps/xr-chaperone.svg
  '';

  __structuredAttrs = true;

  meta = {
    description = "VR Chaperone System for OpenXR ";
    homepage = "https://github.com/FrostyCoolSlug/xr-chaperone";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "xr-chaperone";
    maintainers = with lib.maintainers; [ toasteruwu ];
  };
})
