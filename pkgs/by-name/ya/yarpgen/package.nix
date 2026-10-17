{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yarpgen";
  version = "0-unstable-2025-08-12";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "intel";
    repo = "yarpgen";
    rev = "e0f63b6580cc9f1c50d18928a4273106dc3a6c41";
    hash = "sha256-Y0TH2qiczrNQIZeEsFLzbUPptdwVGZ8NXcniY7LlVoU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp yarpgen $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Random program generator that produces correct runnable C/C++ and DPC++ programs";
    homepage = "https://github.com/intel/yarpgen";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ryanfanchiotti ];
  };
})
