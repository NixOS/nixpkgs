{
  lib,
  stdenv,
  fetchFromGitHub,
  libxft,
  imlib2Full,
  giflib,
  libexif,
  conf ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sxiv";
  version = "26";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "muennich";
    repo = "sxiv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jrCEx1o7Go0jgwQ3YJ0L97Q5BCHvVTTqOWId3xzlSnU=";
  };

  configFile = lib.optionalString (conf != null) (builtins.toFile "config.def.h" conf);
  preBuild = lib.optionalString (conf != null) "cp ${finalAttrs.configFile} config.def.h";

  buildInputs = [
    libxft
    imlib2Full
    giflib
    libexif
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -Dt $out/share/applications sxiv.desktop
  '';

  meta = {
    description = "Simple X Image Viewer";
    homepage = "https://github.com/muennich/sxiv";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ h7x4 ];
    mainProgram = "sxiv";
  };
})
