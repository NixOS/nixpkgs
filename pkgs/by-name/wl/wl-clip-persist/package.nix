{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-clip-persist";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Linus789";
    repo = "wl-clip-persist";
    rev = "v${version}";
    hash = "sha256-uu9R+/8483YyuvMeot2sRs8ihSN1AEPeDjzRxB1P8kc=";
  };

  cargoHash = "sha256-XpNpHi9vl89sbec6DXh50t8s328Uw4PpzFVvGp1TP6o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ wayland ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Keep Wayland clipboard even after programs close";
    homepage = "https://github.com/Linus789/wl-clip-persist";
    inherit (wayland.meta) platforms;
    license = licenses.mit;
    mainProgram = "wl-clip-persist";
    maintainers = with maintainers; [ name-snrl ];
  };
}
