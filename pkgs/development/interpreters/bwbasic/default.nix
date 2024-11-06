{
  lib,
  gccStdenv,
  dos2unix,
  fetchurl,
  unzip,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "bwbasic";
  version = "3.20";

  src = fetchurl {
    url = "mirror://sourceforge/project/bwbasic/bwbasic/version%20${finalAttrs.version}/bwbasic-${finalAttrs.version}.zip";
    hash = "sha256-7hju+rftka0a1QzKsz6wOMSr11NZXhmYKJCGfygjOfE=";
  };

  nativeBuildInputs = [
    dos2unix
    unzip
  ];

  unpackPhase = ''
    unzip $src
  '';

  postPatch = ''
    dos2unix configure
    patchShebangs configure
    chmod +x configure
  '';

  hardeningDisable = [ "format" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Bywater BASIC Interpreter";
    mainProgram = "bwbasic";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ irenes ];
    platforms = lib.platforms.all;
    homepage = "https://sourceforge.net/projects/bwbasic/";
  };
})
