{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zimg";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = "zimg";
    rev = "release-${finalAttrs.version}";
    sha256 = "sha256-T+/wuTxPK+PLofqJm3dujGqGGXhpdGQLjAttTQPsgOI=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = {
    description = "Scaling, colorspace conversion and dithering library";
    homepage = "https://github.com/sekrit-twc/zimg";
    license = lib.licenses.wtfpl;
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
})
