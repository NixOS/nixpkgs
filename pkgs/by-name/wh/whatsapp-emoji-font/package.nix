{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  imagemagick,
  nix-update-script,
  nototools,
  pngquant,
  which,
  zopfli,
}:

stdenvNoCC.mkDerivation rec {
  pname = "whatsapp-emoji-linux";
  version = "2.25.9.78-1";

  src = fetchFromGitHub {
    tag = version;
    owner = "dmlls";
    repo = "whatsapp-emoji-linux";
    hash = "sha256-QopJUT6HAgvrRNQw6adHNOSZUoJO1qiFATXsDQOUf7w=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    imagemagick
    nototools
    pngquant
    which
    zopfli
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WhatsApp Emoji for GNU/Linux";
    homepage = "https://github.com/dmlls/whatsapp-emoji-linux";
    maintainers = [ lib.maintainers.lucasew ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.unfree;
  };
}
