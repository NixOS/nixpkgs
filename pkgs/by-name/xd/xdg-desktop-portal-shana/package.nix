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
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "xdg-desktop-portal-shana";
    rev = "v${version}";
    hash = "sha256-myEqJnXHCByc9CMX8vMDaQQkL84pfW/7fKPZpiNQHJA=";
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

  cargoHash = "sha256-/iJAYG0OjTaRrDtNjypvmSUad8PS0lRfykSxp0fJZ98=";

  meta = with lib; {
    description = "Filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.samuelefacenda ];
  };

}
