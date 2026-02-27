{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  uasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uasm";
  version = "2.57";

  src = fetchFromGitHub {
    owner = "Terraspace";
    repo = "uasm";
    tag = "v${finalAttrs.version}r";
    hash = "sha256-HaiK2ogE71zwgfhWL7fesMrNZYnh8TV/kE3ZIS0l85w=";
  };

  enableParallelBuilding = true;

  makefile =
    if stdenv.hostPlatform.isDarwin then "Makefile-OSX-Clang-64.mak" else "Makefile-Linux-GCC-64.mak";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  # Needed for compiling with GCC > 13
  env.CFLAGS = "-std=c99 -Wno-incompatible-pointer-types -Wno-implicit-function-declaration -Wno-int-conversion";

  installPhase = ''
    runHook preInstall

    install -Dt "$out/bin" -m0755 GccUnixR/uasm
    install -Dt "$out/share/doc/uasm" -m0644 {Readme,History}.txt Doc/*

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = uasm;
    command = "uasm -h";
    version = "v${finalAttrs.version}";
  };

  meta = {
    homepage = "https://www.terraspace.co.uk/uasm.html";
    description = "Free MASM-compatible assembler based on JWasm";
    mainProgram = "uasm";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.zane ];
    license = lib.licenses.watcom;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
