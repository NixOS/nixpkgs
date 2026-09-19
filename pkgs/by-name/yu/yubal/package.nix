{
  lib,
  stdenv,
  fetchFromGitHub,
  python312Packages,
  callPackage,
  python312,
  makeWrapper,
  ffmpeg,
  rsgain,
}:

with python312Packages;
stdenv.mkDerivation (finalAttrs: {
  pname = "yubal";
  version = "0.9.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "guillevc";
    repo = "yubal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OYmEmg1pupCobG4ui0vcZPaZNRzKDTBbBO/XAkwuWXw=";
  };

  web = callPackage ./web.nix { yubal = finalAttrs; };

  yubal-cli = callPackage ./cli.nix { yubal = finalAttrs; };

  yubal-api = callPackage ./api.nix { yubal = finalAttrs; };

  pythonEnv = python312.withPackages (ps: [
    finalAttrs.yubal-api
  ]);

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    ffmpeg
    rsgain
  ];

  installPhase = ''
    mkdir -p $out/web
    cp -r ${finalAttrs.web}/dist $out/web

    makeWrapper ${finalAttrs.pythonEnv}/bin/python $out/bin/yubal \
      --add-flags "-m yubal_api" \
      --set-default YUBAL_ROOT $out \
      --set-default YUBAL_CONFIG ./config \
      --set-default YUBAL_DATA ./data \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          rsgain
        ]
      }
  '';

  meta = with lib; {
    description = "Self-hosted YouTube Music downloader. Tags, organizes, and keeps playlists in sync.";
    homepage = "https://github.com/guillevc/yubal";
    mainProgram = "yubal";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.skullgirl ];
  };
})
