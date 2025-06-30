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

stdenv.mkDerivation rec {
  version = "0.52.1";
  pname = "xcpc";

  src = fetchFromGitHub {
    owner = "ponceto";
    repo = "xcpc-emulator";
    rev = "xcpc-${version}";
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

  meta = with lib; {
    description = "Portable Amstrad CPC 464/664/6128 emulator written in C";
    homepage = "https://www.xcpc-emulator.net";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "xcpc";
  };
}
