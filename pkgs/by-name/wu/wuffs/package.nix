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
  version = "0.4.0-alpha.9";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "wuffs";
    tag = "v" + finalAttrs.version;
    hash = "sha256-XbupK4QYnPudUlO5tRWrQRncGHITzJL//Yk/E7WNxYk=";
  };

  vendorHash = null;

  strictDeps = true;
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

      install -Dm444 release/c/wuffs-unsupported-snapshot.c "$dev/include/wuffs/wuffs-v0.4.c"

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
    maintainers = with lib.maintainers; [
      RossSmyth
    ];
  };
})
