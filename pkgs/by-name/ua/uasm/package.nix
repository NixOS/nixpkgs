{
  lib,
  gcc13Stdenv,
  fetchFromGitHub,
  testers,
  uasm,
}:

let
  stdenv = gcc13Stdenv;
in
stdenv.mkDerivation rec {
  pname = "uasm";
  version = "2.57";

  src = fetchFromGitHub {
    owner = "Terraspace";
    repo = "uasm";
    tag = "v${version}r";
    hash = "sha256-HaiK2ogE71zwgfhWL7fesMrNZYnh8TV/kE3ZIS0l85w=";
  };

  enableParallelBuilding = true;

  makefile =
    if gcc13Stdenv.hostPlatform.isDarwin then
      "Makefile-OSX-Clang-64.mak"
    else
      "Makefile-Linux-GCC-64.mak";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall

    install -Dt "$out/bin" -m0755 GccUnixR/uasm
    install -Dt "$out/share/doc/${pname}" -m0644 {Readme,History}.txt Doc/*

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = uasm;
    command = "uasm -h";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://www.terraspace.co.uk/uasm.html";
    description = "Free MASM-compatible assembler based on JWasm";
    mainProgram = "uasm";
    platforms = platforms.unix;
    maintainers = with maintainers; [ thiagokokada ];
    license = licenses.watcom;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
