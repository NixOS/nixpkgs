{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook269,
  gnat,
  # use gprbuild-boot since gprbuild proper depends
  # on this xmlada derivation.
  gprbuild-boot,
}:

stdenv.mkDerivation rec {
  pname = "xmlada";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "xmlada";
    tag = "v${version}";
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
}
