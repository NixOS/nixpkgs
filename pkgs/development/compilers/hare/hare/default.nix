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
stdenv.mkDerivation (finalAttrs: {
  pname = "hare";
  version = "unstable-2023-03-15";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare";
    rev = "488771bc8cef15557a44815eb6f7808df40a09f7";
    hash = "sha256-1cSXWD8jpW1VJZDTDOkIabczqbaDCOWsyaUSGtsKsUM=";
  };

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
