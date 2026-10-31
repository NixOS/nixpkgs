{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  autoreconfHook269,
  gnat,
  # use gprbuild-boot since gprbuild proper depends
  # on this xmlada derivation.
  gprbuild-boot,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xmlada";
  version = "26.0.0";

  src = fetchFromGitHub {
    name = "xmlada-${finalAttrs.version}-src";
    owner = "AdaCore";
    repo = "xmlada";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+7SaLykENypvpx/C5a93DBjusltFNEsVH1pTkfsKwPU=";
  };

  nativeBuildInputs = [
    gnat
    gprbuild-boot
    autoreconfHook269
  ];

  makeFlags = [
    "PROCESSORS=$(NIX_BUILD_CORES)"
  ];

  meta = {
    description = "XML/Ada: An XML parser for Ada";
    homepage = "https://github.com/AdaCore/xmlada";
    maintainers = with lib.maintainers; [
      sternenseemann
      sempiternal-aurora
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
