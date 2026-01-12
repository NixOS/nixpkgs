{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "variant-lite";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "variant-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+1eSnn7eN8iN6vZg3Qz2m7u1ukWimhUQ+WHXQL4rQco=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    # https://github.com/martinmoene/variant-lite/issues/50
    (lib.cmakeBool "VARIANT_LITE_OPT_BUILD_TESTS" false)
  ];

  doCheck = true;
  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "C++17-like variant, a type-safe union for C++98, C++11 and later in a single-file header-only library";
    homepage = "https://github.com/martinmoene/variant-lite";
    changelog = "https://github.com/martinmoene/variant-lite/blob/v${finalAttrs.version}/CHANGES.txt";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ titaniumtown ];
  };
})
