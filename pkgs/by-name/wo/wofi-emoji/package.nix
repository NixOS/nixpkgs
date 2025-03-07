{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  jq,
  wofi,
  wtype,
  wl-clipboard,
}:

let
  emojiJSON = fetchurl {
    url = "https://raw.githubusercontent.com/muan/emojilib/v3.0.11/dist/emoji-en-US.json";
    hash = "sha256-WHqCSNgDzc6ZASdVrwPvsU4MtBcYLKDp2D2Hykrq1sI=";
  };
in
stdenv.mkDerivation rec {
  pname = "wofi-emoji";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Zeioth";
    repo = "wofi-emoji";
    rev = "v${version}";
    hash = "sha256-wLZK7RcDxxlYuu27WNj+SoRoBiCqk9whp4Fyg0SOoPA=";
  };

  nativeBuildInputs = [ jq ];
  buildInputs = [
    wofi
    wtype
    wl-clipboard
  ];

  postPatch = ''
    substituteInPlace build.sh \
      --replace 'curl ${emojiJSON.url}' 'cat ${emojiJSON}'
    substituteInPlace wofi-emoji \
      --replace 'wofi' '${wofi}/bin/wofi' \
      --replace 'wtype' '${wtype}/bin/wtype' \
      --replace 'wl-copy' '${wl-clipboard}/bin/wl-copy'
  '';

  buildPhase = ''
    runHook preBuild

    bash build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp wofi-emoji $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Simple emoji selector for Wayland using wofi and wl-clipboard";
    homepage = "https://github.com/Zeioth/wofi-emoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      johnrtitor
      ymarkus
    ];
    platforms = lib.platforms.all;
    mainProgram = "wofi-emoji";
  };
}
