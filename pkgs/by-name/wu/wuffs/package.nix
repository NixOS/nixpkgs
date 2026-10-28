{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  replaceVars,
  testers,
}:
let
  compiler =
    if stdenv.cc.isClang then
      "clang"
    else if stdenv.cc.isGNU then
      "gcc"
    else
      throw "unsupported compiler";
in
buildGoModule (finalAttrs: {
  pname = "wuffs";
  version = "0.3.6";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "wuffs";
    tag = "v" + finalAttrs.version;
    hash = "sha256-TxvmC5eEuJhAdHh2cSVI9GJHOvFLWIOpAIJA9m4xWYQ=";
  };

  vendorHash = "sha256-CRzsGHE3K/WWPX0A3B1CvvEdADlxdIhaT5fOtaA3LPo=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  subPackages = [
    "cmd/wuffs-c"
    "cmd/wuffs"
  ];

  # There are no checks
  doCheck = false;

  postInstall =
    let
      pkgconfig = replaceVars ./wuffs.pc {
        LIB = placeholder "lib";
        DEV = placeholder "dev";
        DESCRIPTION = finalAttrs.meta.description;
        VERSION = finalAttrs.version;
      };
    in
    ''
      wrapProgram "$out/bin/wuffs" \
        --prefix PATH : "$out/bin"

      "$out/bin/wuffs" gen std/...
      "$out/bin/wuffs" genlib -ccompilers=${compiler}

      install -Dm444 -t "$lib/lib" gen/lib/c/${compiler}-dynamic/libwuffs.*

      install -Dm444 release/c/wuffs-v0.3.c "$dev/include/wuffs/wuffs-v0.3.c"

      install -Dm444 ${pkgconfig} "$dev/lib/pkgconfig/wuffs.pc"
    '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "https://github.com/google/wuffs";
    description = "memory-safe programming language and standard library for wrangling untrusted data";
    mainProgram = "wuffs";
    pkgConfigModules = [ "wuffs" ];
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ schembriaiden ];
  };
})
