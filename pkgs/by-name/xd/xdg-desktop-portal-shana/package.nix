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
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "Decodetalkers";
    repo = "xdg-desktop-portal-shana";
    rev = "v${version}";
    hash = "sha256-9uie6VFyi7sO8DbthUTgpEc68MvvLA+bUwyV/DSpKkE=";
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-f9kfCoH0YHVzzZC4rChJgz0yQqVVAYR7Gpa6HuXhQZY=";

  meta = with lib; {
    description = "Filechooser portal backend for any desktop environment";
    homepage = "https://github.com/Decodetalkers/xdg-desktop-portal-shana";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.samuelefacenda ];
  };

}
