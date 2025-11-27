{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # passthru.tests
  tmux,
  fcft,
  arrow-cpp,
  # build config
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = "utf8proc";
    rev = "v${version}";
    hash = "sha256-/+/IrsLQ9ykuVOaItd2ZbX60pPlP2omvS1qJz51AnWA=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!enableStatic))
    (lib.cmakeBool "UTF8PROC_ENABLE_TESTING" doCheck)
  ];

  doCheck = true;

  passthru.tests = {
    inherit fcft tmux arrow-cpp;
  };

  meta = with lib; {
    description = "Clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [
      maintainers.ftrvxmtrx
      maintainers.sternenseemann
    ];
  };
}
