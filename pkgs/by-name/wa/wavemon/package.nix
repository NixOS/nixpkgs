{
  lib,
  stdenv,
  fetchFromGitHub,
  libnl,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wavemon";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OnELXlnzXamQflCAWuc4fxwvqHZtl+nrlTpkKK4IGKw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libnl
    ncurses
  ];

  meta = {
    description = "Ncurses-based monitoring application for wireless network devices";
    homepage = "https://github.com/uoaerg/wavemon";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      fpletz
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wavemon";
  };
})
