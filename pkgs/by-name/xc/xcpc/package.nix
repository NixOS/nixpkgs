{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  wrapGAppsHook3,
  libepoxy,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.52.1";
  pname = "xcpc";

  src = fetchFromGitHub {
    owner = "ponceto";
    repo = "xcpc-emulator";
    rev = "xcpc-${finalAttrs.version}";
    hash = "sha256-N4UfnCbebaAhx0490niMov/JqlrXt5goblWbW0ajkcc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [ libepoxy ];

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    substituteInPlace $out/share/applications/xcpc.desktop --replace-fail \
      "$out/bin/" ""
    substituteInPlace $out/share/applications/xcpc.desktop --replace-fail \
      "$out/share/pixmaps/" ""
  '';

  meta = {
    description = "Portable Amstrad CPC 464/664/6128 emulator written in C";
    homepage = "https://www.xcpc-emulator.net";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "xcpc";
  };
})
