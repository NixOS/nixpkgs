{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ttf-envy-code-r";
  version = "PR7";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchzip {
    url = "https://dl.damieng.com/fonts/original/EnvyCodeR-${finalAttrs.version}.zip";
    hash = "sha256-pJqC/sbNjxEwbVf2CVoXMBI5zvT3DqzRlKSqFT8I2sM=";
  };

  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    install -Dm644 *.txt -t $doc/share/doc/${finalAttrs.pname}-${finalAttrs.version}
  '';

  meta = {
    homepage = "https://damieng.com/typography/";
    description = "Free scalable coding font by DamienG";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
  };
})
