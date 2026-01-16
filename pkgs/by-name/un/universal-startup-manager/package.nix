{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
}:

rustPlatform.buildRustPackage rec {
  pname = "universal-startup-manager";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "boo15mario";
    repo = "universal-startup-manager";
    rev = "v${version}";
    hash = "sha256-PpwrEoWwrUu/rMUzbXFmIOrPWW9wGH7H2fgL9tVJZhY=";
  };

  cargoHash = "sha256-+BW4hrSn6WECdaklCx+KQLn/hu2vhkSfrXq2+2QK+hk=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
  ];

  meta = {
    description = "Manage startup applications across different environments";
    homepage = "https://github.com/boo15mario/universal-startup-manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "universal-startup-manager";
    platforms = lib.platforms.linux;
  };
}
