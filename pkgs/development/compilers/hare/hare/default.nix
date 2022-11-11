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

stdenv.mkDerivation (finalAttrs: {
  pname = "hare";
  version = "unstable-2022-07-30";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare";
    rev = "296925c91d79362d6b8ac94e0336a38e9af0f1c9";
    hash = "sha256-LeIUnpTMZ6vxgAy/LPm9/IMit41RgezdVESIv+gQFHc=";
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

  meta = with lib; {
    homepage = "http://harelang.org/";
    description =
      "A systems programming language designed to be simple, stable, and robust";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (harec.meta) platforms badPlatforms;
  };
})
