{ lib
, stdenv
, fetchFromSourcehut
, binutils-unwrapped
, harec
, makeWrapper
, qbe
, scdoc
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "hare";
  version = "unstable-2022-06-18";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = "ac9b2c35c09d555e09dbd81c5ed95bdfa14313ba";
    hash = "sha256-eeS14LGkbi9IamvKzK+HF0Rvk9NFp4QVYcrHwNSNBx4=";
  };

  patches = [ ./disable-failing-test-cases.patch ];

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

  setupHook = ./setup-hook.sh;
  strictDeps = true;

  configurePhase =
    let
      # https://harelang.org/platforms/
      arch =
        if stdenv.isx86_64 then "x86_64"
        else if stdenv.isAarch64 then "aarch64"
        else if stdenv.isRiscV64 then "riscv64"
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

  meta = with lib; {
    homepage = "http://harelang.org/";
    description =
      "A systems programming language designed to be simple, stable, and robust";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (harec.meta) platforms badPlatforms;
  };
}
