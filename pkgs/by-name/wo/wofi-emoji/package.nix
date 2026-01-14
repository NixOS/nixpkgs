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
    url = "https://raw.githubusercontent.com/muan/emojilib/v4.0.0/dist/emoji-en-US.json";
    hash = "sha256-IoU9ZPCqvSPX4DmfC+r5MiglhFc41XMRrbJRL9ZNrvs=";
  };
in
stdenv.mkDerivation rec {
  pname = "wofi-emoji";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Zeioth";
    repo = "wofi-emoji";
    tag = "v${version}";
    hash = "sha256-NHiAAPRbIz0sC5yh9DTDmIU3zDBFIlUsbpW4HAPr5C8=";
  };

  nativeBuildInputs = [ jq ];

  buildInputs = [
    wofi
    wtype
    wl-clipboard
  ];

  postPatch = ''
    substituteInPlace build.sh \
      --replace-fail 'curl ${emojiJSON.url}' 'cat ${emojiJSON}'
    substituteInPlace wofi-emoji \
      --replace-fail 'wofi' '${wofi}/bin/wofi' \
      --replace-fail 'wtype' '${wtype}/bin/wtype' \
      --replace-fail 'wl-copy' '${wl-clipboard}/bin/wl-copy'
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
