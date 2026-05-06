{
  rustPlatform,
  fetchFromGitHub,
  autoPatchelfHook,
  cmake,
  git,
  python3,
  openxr-loader,
  libxkbcommon,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xr-chaperone";
  version = "0-unstable-2026-03-16";

  src = fetchFromGitHub {
    owner = "FrostyCoolSlug";
    repo = "xr-chaperone";
    rev = "bb3a78dc8abc802f51b4a257a019b31e0e03c940";
    hash = "sha256-djMOvA1XIYlQgXxBNEbCbSdHAMOmyUGTVqeIEV8Nv3c=";
  };

  cargoHash = "sha256-9uEosKwKGNruwxp/uslXj0WAFowY4Tu2CikWa2JiOf4=";

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    git
    python3
  ];

  buildInputs = [ openxr-loader ];

  runtimeDependencies = [
    libxkbcommon
  ];

  postInstall = ''
    install -m 444 -D resources/xr-chaperone.desktop $out/share/applications/${finalAttrs.pname}.desktop
    install -m 444 -D resources/xr-chaperone.png $out/share/icons/hicolor/256x256/apps/${finalAttrs.pname}.png
    install -m 444 -D resources/xr-chaperone.svg $out/share/icons/hicolor/scalable/apps/${finalAttrs.pname}.svg
  '';

  __structuredAttrs = true;

  meta = {
    description = "VR Chaperone System for OpenXR ";
    homepage = "https://github.com/FrostyCoolSlug/xr-chaperone";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "xr-chaperone";
    maintainers = with lib.maintainers; [ toasteruwu ];
  };
})
