{
  lib,
  rustPlatform,
  fetchFromGitHub,
  meson,
  ninja,
  xdg-desktop-portal,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-shana";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "xdg-desktop-portal-shana";
    rev = "v${version}";
    hash = "sha256-bBKoAegT3wk2UD2fqSLaix2MuKtVAcHA6vcB9VAzLJw=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    xdg-desktop-portal
  ];

  # Needed for letting meson run. rustPackage will overwrite it otherwise.
  configurePhase = "";

  mesonBuildType = "release";

  cargoHash = "sha256-vufD/eYulblUKQVHsyvjl2AlRoRAGp2oeYol9kTt3lQ=";

  meta = with lib; {
    description = "Filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.samuelefacenda ];
  };

}
