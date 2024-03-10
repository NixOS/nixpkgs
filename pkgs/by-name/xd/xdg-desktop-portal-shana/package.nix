{ lib
, rustPlatform
, fetchFromGitHub
, meson
, ninja
, xdg-desktop-portal
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-shana";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "xdg-desktop-portal-shana";
    rev = "v${version}";
    sha256 = "cgiWlZbM0C47CisR/KlSV0xqfeKgM41QaQihjqSy9CU=";
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

  cargoHash = "sha256-uDM4a7AB0753c/H1nfic/LjWrLmjEvi/p2S/tLIDXaQ=";

  meta = with lib; {
    description = "A filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [  maintainers.samuelefacenda ];
  };

}
