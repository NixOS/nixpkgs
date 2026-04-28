{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchurl,
  automake,
  autoconf,

  # passthru
  testers,
  smlnj,
}:
let
  version = "2026.1";
  src = fetchFromGitHub {
    owner = "smlnj";
    repo = "smlnj";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-n5oWhignhFl8B/cXSO3g/KQXInZqT1A0Mp8GzLeGqNc=";
  };

  llvm = callPackage ./llvm.nix { inherit src version; };

  bootFile =
    if stdenv.hostPlatform.isUnix && stdenv.hostPlatform.isx86_64 then
      fetchurl {
        url = "https://smlnj.cs.uchicago.edu/dist/working/${version}/boot.amd64-unix.tgz";
        hash = "sha256-caFguKkhFOjgJDtcOcF6YAbzFl2nQYXbtWCjvaBjL6o=";
      }
    else if stdenv.hostPlatform.isUnix && stdenv.hostPlatform.isAarch64 then
      fetchurl {
        url = "https://smlnj.cs.uchicago.edu/dist/working/${version}/boot.arm64-unix.tgz";
        hash = "sha256-qygH0n163jiwm4CsltPeCCpHqnBxCHKP5O20GZyq1/0=";
      }
    else
      throw "Unsupported host platform: ${stdenv.hostPlatform.config}";

in
stdenv.mkDerivation {
  pname = "smlnj";
  inherit src version;

  nativeBuildInputs = [
    autoconf
    automake
  ];

  __structuredAttrs = true;
  strictDeps = true;

  patchPhase = ''
    unpackFile ${bootFile}
    mkdir -pv runtime/bin runtime/lib
    ln -s ${llvm}/bin/llvm-config     runtime/bin/llvm-config
    ln -s ${llvm}/lib/libCFGCodeGen.a runtime/lib/libCFGCodeGen.a
  '';

  buildPhase = ''
    export INSTALLDIR=$out
    mkdir -pv $out
    ./build.sh
  '';

  passthru.llvm = llvm;
  passthru.tests.version = testers.testVersion {
    package = smlnj;
    command = "sml @SMLversion";
  };

  meta = {
    description = "Standard ML of New Jersey, a compiler";
    homepage = "http://smlnj.org";
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      skyesoss
    ];
    mainProgram = "sml";
  };
}
