{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  atk,
  gtk3,
  glib,
}:

rustPlatform.buildRustPackage rec {
  pname = "filepicker";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "paulrouget";
    repo = "static-filepicker";
    rev = "v${version}";
    hash = "sha256-7sRzf3SA9RSBf4O36olXgka8c6Bufdb0qsuTofVe55s=";
  };

  cargoHash = "sha256-HUNBGG1+LsjaDsJS4p5aAdCRyltylQUtdydGSoUdNgo=";

  buildInputs = [
    atk
    gtk3
    glib
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "File picker used by VDHCoApp";
    homepage = "https://github.com/paulrouget/static-filepicker";
    license = licenses.gpl2;
    mainProgram = "filepicker";
    maintainers = with maintainers; [ hannesgith ];
  };
}
