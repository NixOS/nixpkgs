{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libX11,
  libxkbfile,
}:

stdenv.mkDerivation rec {
  pname = "xkb-switch";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "ierton";
    repo = "xkb-switch";
    rev = version;
    sha256 = "sha256-DZAIL6+D+Hgs+fkJwRaQb9BHrEjAkxiqhOZyrR+Mpuk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libX11
    libxkbfile
  ];

  meta = {
    description = "Switch your X keyboard layouts from the command line";
    homepage = "https://github.com/ierton/xkb-switch";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ smironov ];
    platforms = lib.platforms.linux;
    mainProgram = "xkb-switch";
  };
}
