{ stdenvNoCC
, lib
, fetchFromGitHub
, imagemagick
, nix-update-script
, pngquant
, python3Packages
, which
, zopfli
}:

stdenvNoCC.mkDerivation rec {
  pname = "whatsapp-emoji-linux";
  version = "2.23.2.72-1";

  src = fetchFromGitHub {
    rev = "refs/tags/${version}";
    owner = "dmlls";
    repo = "whatsapp-emoji-linux";
    hash = "sha256-dwX+y8jCpR+SyiH13Os9VeXLDwmAYB7ARW2lAMl/7RE=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    imagemagick
    pngquant
    python3Packages.nototools
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
