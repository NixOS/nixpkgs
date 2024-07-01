{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  autoPatchelfHook,
  qt6,
}:
stdenv.mkDerivation {
  pname = "vgmtrans";
  version = "1.1-unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "vgmtrans";
    repo = "vgmtrans";
    rev = "6f6f86823ab10ce72f0c6acd6ef7991e631613f7";
    hash = "sha256-PDbWwK16HyST/UeC9k/ycLKBPpJSIsjeTdGGxNgEIGE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  postInstall =
    let
      dylibs =
        lib.optionalString stdenv.isAarch64 "aarch64/"
        + lib.optionalString stdenv.isUnix "lib"
        + "bass{,midi}"
        + stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      # Make the bundled libbass visible to autoPatchelfHook
      install -D ../lib/bass/${dylibs} -t $out/lib
    '';

  meta = {
    description = "Tool to convert proprietary, sequenced videogame music to industry-standard formats";
    homepage = "https://github.com/vgmtrans/vgmtrans";

    license = with lib.licenses; [
      zlib
      libpng
      bsd3 # oki_adpcm_state
    ];

    # See CMakePresets.json
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-windows"
      "aarch64-windows"
    ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "vgmtrans";
  };
}
