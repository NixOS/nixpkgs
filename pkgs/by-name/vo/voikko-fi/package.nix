{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  python3,
  foma,
  libvoikko,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "voikko-fi";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "voikko";
    repo = "corevoikko";
    tag = "rel-voikko-fi-${finalAttrs.version}";
    hash = "sha256-yYV8DHhILpcAG9gbEO67fdrX44Z2hOqkLbp9bBTSNuk=";
  };

  sourceRoot = "${finalAttrs.src.name}/voikko-fi";

  enableParallelBuilding = true;

  installTargets = "vvfst-install DESTDIR=$(out)/share/voikko-fi";

  nativeBuildInputs = [
    python3
    foma
    libvoikko
  ];

  meta = {
    homepage = "https://voikko.puimula.org";
    description = "Description of Finnish morphology written for libvoikko";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ lajp ];
    platforms = lib.platforms.unix;
  };
})
