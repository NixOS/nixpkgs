{
  cmake,
  cpu_features,
  fetchFromGitHub,
  lib,
  replaceVars,
  scalablevectorsearch,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vectorsimilarity";
  version = "8.6.0-unstable-2026-05-04";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RedisAI";
    repo = "VectorSimilarity";
    rev = "8c5791f3977701e178c64193ef865b9ca513decf";
    hash = "sha256-y+dDWy4x5nuwRt5x6fq9mKeVoP2sXzM8tiH+d6BMHp0=";
  };

  patches = [
    ./install.patch
    ./svs-find-package.patch
    (replaceVars ./external-libs.patch {
      cpu_features_src = cpu_features.src;
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "VECSIM_BUILD_TESTS" false)
    (lib.cmakeFeature "VECSIM_LIBTYPE" "SHARED")
    (lib.cmakeBool "SVS_SHARED_LIB" false)
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ scalablevectorsearch ];

  meta = {
    description = "Redis vector similarity search library";
    homepage = "https://github.com/RedisAI/VectorSimilarity";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
