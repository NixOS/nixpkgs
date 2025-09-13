{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  fetchpatch2,
  ninja,
  cmake,
  SDL2,
  SDL2_mixer,
  unzip,
  buildShareware ? false,
  withSharewareData ? buildShareware,
}:
assert withSharewareData -> buildShareware;

let
  datadir = "share/data/rott-shareware/";
  sharewareData = fetchzip {
    url = "http://icculus.org/rott/share/1rott13.zip";
    hash = "sha256-l0pP+mNPAabGh7LZrwcB6KOhPRSycrZpAlPVTyDXc6Y=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taradino" + lib.optionalString buildShareware "-shareware";
  version = "20250816";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "taradino";
    tag = finalAttrs.version;
    hash = "sha256-SPDO5/COisW0LkFQgzCZDvcFZ1Mr2bX/XvUKJADQJ9c=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/fabiangreffrath/taradino/pull/117
      name = "Fix TARADINO_DATADIR CMake option comparison";
      url = "https://github.com/fabiangreffrath/taradino/commit/4653f0b5aadca1790fdc0b1b7bc174d1784f15bd.patch?full_index=1";
      hash = "sha256-XdFBNsBQlJY4ZSpCW/XHHjLwovCVNREOmyV3Df+PEWE=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optional withSharewareData unzip;

  buildInputs = [
    SDL2
    SDL2_mixer
  ];

  cmakeFlags =
    lib.optionals buildShareware [
      (lib.cmakeBool "TARADINO_SHAREWARE" true)
      (lib.cmakeFeature "TARADINO_SUFFIX" "shareware")
    ]
    ++ lib.optional withSharewareData (
      lib.cmakeFeature "TARADINO_DATADIR" "${placeholder "out"}/${datadir}"
    );

  postInstall = lib.optionalString withSharewareData ''
    mkdir -p "$out/${datadir}"
    unzip -d "$out/${datadir}" ${sharewareData}/ROTTSW13.SHR
  '';

  meta = {
    description = "SDL2 port of Rise of the Triad";
    mainProgram = "taradino" + lib.optionalString buildShareware "-shareware";
    homepage = "https://github.com/fabiangreffrath/taradino";
    license = with lib.licenses; [ gpl2Plus ] ++ lib.optional withSharewareData unfreeRedistributable;
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.all;
  };
})
