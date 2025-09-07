{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  ninja,
  libX11,
  libXxf86vm,
  libXrandr,
  samurai,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcalib";
  version = "0.11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "OpenICC";
    repo = "xcalib";
    tag = finalAttrs.version;
    hash = "sha256-o0pizV4Qrb9wfVKVNH2Ifb9tr7N7iveVHQB39WVCl8w=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libX11
    libXxf86vm
    libXrandr
    samurai
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Tiny monitor calibration loader for X and MS-Windows";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "xcalib";
  };
})
