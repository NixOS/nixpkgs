{
  autoreconfHook,
  fetchFromGitHub,
  gitUpdater,
  lib,
  libiconv,
  libintl,
  stdenv,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zvbi";
  version = "0.2.43";

  src = fetchFromGitHub {
    owner = "zapping-vbi";
    repo = "zvbi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Pj37lJSa1spjC/xrf+yu/ecFCuajb8ingszp6ib2WC8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    validatePkgConfig
  ];

  propagatedBuildInputs = [
    libiconv
    libintl
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Vertical Blanking Interval (VBI) utilities";
    homepage = "https://github.com/zapping-vbi/zvbi";
    changelog = "https://github.com/zapping-vbi/zvbi/blob/${finalAttrs.src.rev}/ChangeLog";
    pkgConfigModules = [ "zvbi-0.2" ];
    license = with lib.licenses; [
      bsd2
      bsd3
      gpl2
      gpl2Plus
      lgpl21Plus
      lgpl2Plus
      mit
    ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
