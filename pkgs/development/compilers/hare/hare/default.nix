{ lib
, stdenv
, fetchFromSourcehut
, binutils-unwrapped
, harePackages
, makeWrapper
, qbe
, scdoc
, substituteAll
}:

let
  inherit (harePackages) harec;
in
stdenv.mkDerivation (self: {
  pname = "hare";
  version = "unstable-2023-02-10";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare";
    rev = "52b3f2d0c7a85e04a79666a954101e527b7f1272";
    hash = "sha256-/zP8LbZ113Ar06MZF1zP20LKMGko+4HcOXSntLVAQAU=";
  };

  patches = [
    ./000-disable-failing-test-cases.diff
  ];

  nativeBuildInputs = [
    binutils-unwrapped
    harec
    makeWrapper
    qbe
    scdoc
  ];

  buildInputs = [
    binutils-unwrapped
    harec
    qbe
  ];

  strictDeps = true;

  configurePhase =
    let
      # https://harelang.org/platforms/
      arch =
        if stdenv.isx86_64 then "x86_64"
        else if stdenv.isAarch64 then "aarch64"
        else if stdenv.hostPlatform.isRiscV && stdenv.is64bit then "riscv64"
        else "unsupported";
      platform =
        if stdenv.isLinux then "linux"
        else if stdenv.isFreeBSD then "freebsd"
        else "unsupported";
      hareflags = "";
      config-file = substituteAll {
        src = ./config-template.mk;
        inherit arch platform hareflags;
      };
    in
      ''
        runHook preConfigure

        export HARECACHE="$NIX_BUILD_TOP/.harecache"
        export BINOUT="$NIX_BUILD_TOP/.bin"
        cat ${config-file} > config.mk

        runHook postConfigure
      '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  doCheck = true;

  postInstall =
    let
      binPath = lib.makeBinPath [
        binutils-unwrapped
        harec
        qbe
      ];
    in
      ''
        wrapProgram $out/bin/hare --prefix PATH : ${binPath}
      '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://harelang.org/";
    description =
      "A systems programming language designed to be simple, stable, and robust";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.AndersonTorres ];
    inherit (harec.meta) platforms badPlatforms;
    broken = stdenv.isAarch64; # still figuring how to set cross-compiling stuff
  };
})
