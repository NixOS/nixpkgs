{ lib
, rustPlatform
, fetchFromGitHub
, meson
, ninja
, xdg-desktop-portal
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-shana";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "xdg-desktop-portal-shana";
    rev = "v${version}";
    sha256 = "sha256-bUskzFDd4qjH4Isp6vAJHe5qzgCLudQbkh+JNNTSMu8=";
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

  cargoHash = "sha256-FzEdQePDnSCuMDqbz0ZUywDzNfbiOwottSrE+eWL9to=";

  meta = with lib; {
    description = "Filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [  maintainers.samuelefacenda ];
  };

}
