{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # passthru.tests
  tmux,
  fcft,
  arrow-cpp,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "utf8proc";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = "utf8proc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/+/IrsLQ9ykuVOaItd2ZbX60pPlP2omvS1qJz51AnWA=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!enableStatic))
    (lib.cmakeBool "UTF8PROC_ENABLE_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  passthru.tests = {
    inherit fcft tmux arrow-cpp;
  };

  meta = {
    description = "Clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [
      lib.maintainers.ftrvxmtrx
      lib.maintainers.sternenseemann
    ];
  };
})
