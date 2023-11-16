{ android-tools
, cargo
, clang
, cmake
, fetchFromGitHub
, fontconfig
, freetype
, lib
, libglvnd
, makeWrapper
, mold
, pkg-config
, rustPlatform
, rustc
, stdenv
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "universal-android-debloater";
  version = "unstable-2023-04-10";

  src = fetchFromGitHub {
    owner = "0x192";
    repo = pname;
    rev = "11f27c671cba278d71296cdef4c5a5dba06add5e";
    hash = "sha256-5vGn7FRkko44rkMID23XK1YTjFBuhA4Hz8h49gB/L2Q=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [
    cargo
    clang
    cmake
    mold
    pkg-config
    rustc
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    freetype
    libglvnd
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];

  # Checks would fail with: "file cannot create directory: /var/empty/local/lib."
  doCheck = false;

  buildFeatures = [ "iced/glow" ];
  postInstall = ''
    wrapProgram $out/bin/uad_gui \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ fontconfig freetype libglvnd xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi ]} \
      --suffix PATH : ${lib.makeBinPath [ android-tools ]}
    '';

  meta = with lib; {
    description = "Universal Android Debloater";
    homepage = "https://github.com/0x192/universal-android-debloater";
    license = licenses.gpl3;
    mainProgram = "uad_gui";
    maintainers = with maintainers; [ gesperon ];
    platforms = platforms.linux;
  };
}
