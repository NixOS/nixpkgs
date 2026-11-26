{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zimg";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = "zimg";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-T+/wuTxPK+PLofqJm3dujGqGGXhpdGQLjAttTQPsgOI=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Scaling, colorspace conversion and dithering library";
    homepage = "https://github.com/sekrit-twc/zimg";
    license = lib.licenses.wtfpl;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    pkgConfigModules = [ "zimg" ];
  };
})
