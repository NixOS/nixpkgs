{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  wayland,
  libGL,
}:

rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = "wpaperd";
    rev = version;
    hash = "sha256-eCD+eNdiVWLEmpkt0EaID534t6eE2OIVCgWMie5kbFE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AhIBTDtsyLoKRBE1V+DD9ofCz9XknWA4fn5AQ8O0upQ=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    wayland
    libGL
    libxkbcommon
  ];

  meta = with lib; {
    description = "Minimal wallpaper daemon for Wayland";
    longDescription = ''
      It allows the user to choose a different image for each output (aka for each monitor)
      just as swaybg. Moreover, a directory can be chosen and wpaperd will randomly choose
      an image from it. Optionally, the user can set a duration, after which the image
      displayed will be changed with another random one.
    '';
    homepage = "https://github.com/danyspin97/wpaperd";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      DPDmancul
      fsnkty
    ];
    mainProgram = "wpaperd";
  };
}
