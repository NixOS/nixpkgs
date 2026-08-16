{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  nix-update-script,
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
    stripRoot = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taradino" + lib.optionalString buildShareware "-shareware";
  version = "20251222";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "taradino";
    tag = finalAttrs.version;
    hash = "sha256-nB6FNET9OCgK7xqku5gaXfuaIIhYPj8Lo03gINCZSFI=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals withSharewareData [ unzip ];

  buildInputs = [
    SDL2
    SDL2_mixer
  ];

  cmakeFlags =
    lib.optionals buildShareware [
      (lib.cmakeBool "TARADINO_SHAREWARE" true)
      (lib.cmakeFeature "TARADINO_SUFFIX" "shareware")
    ]
    ++ lib.optionals withSharewareData [
      (lib.cmakeFeature "TARADINO_DATADIR" "${placeholder "out"}/${datadir}")
    ];

  postInstall = lib.optionalString withSharewareData ''
    mkdir -p "$out/${datadir}"
    unzip -d "$out/${datadir}" ${sharewareData}/ROTTSW13.SHR
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SDL2 port of Rise of the Triad";
    mainProgram = "taradino" + lib.optionalString buildShareware "-shareware";
    homepage = "https://github.com/fabiangreffrath/taradino";
    license =
      with lib.licenses;
      [ gpl2Plus ] ++ lib.optionals withSharewareData [ unfreeRedistributable ];
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.all;
  };
})
