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
    repo = "UASM";
    tag = "v${finalAttrs.version}r";
    hash = "sha256-HaiK2ogE71zwgfhWL7fesMrNZYnh8TV/kE3ZIS0l85w=";
  };

  enableParallelBuilding = true;

  makefile =
    if stdenv.hostPlatform.isDarwin then
      "Makefile-OSX-Clang-64.mak"
    else if stdenv.hostPlatform.isWindows then
      "Makefile-DOS-GCC.mak"
    else
      "Makefile-Linux-GCC-64.mak";

  # Needed for compiling with GCC > 13
  env.NIX_CFLAGS_COMPILE = lib.escapeShellArgs [
    "-std=c99"
    "-Wno-incompatible-pointer-types"
    "-Wno-int-conversion"
    "-Wno-implicit-function-declaration"
  ];

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isWindows then
        ''
          install -Dm0755 DJGPPr/hjwasm.exe "$out/bin/hjwasm.exe"
          install -Dm0755 DJGPPr/hjwasm.exe "$out/bin/uasm.exe"
        ''
      else
        ''
          install -Dt "$out/bin" -m0755 GccUnixR/uasm
        ''
    }
    install -Dt "$out/share/doc/${finalAttrs.pname}" -m0644 {Readme,History}.txt Doc/*

    runHook postInstall
  '';

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace Makefile-DOS-GCC.mak \
      --replace-fail "gcc.exe" "${stdenv.cc.targetPrefix}cc"

    substituteInPlace Makefile-Linux-GCC-64.mak \
      --replace-fail "CC = gcc" "CC=${stdenv.cc.targetPrefix}cc"
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
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [
      zane
      ccicnce113424
    ];
    license = lib.licenses.watcom;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
