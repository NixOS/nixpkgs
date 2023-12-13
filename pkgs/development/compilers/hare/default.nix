{ lib
, stdenv
, fetchFromSourcehut
, binutils-unwrapped
, harec
, makeWrapper
, qbe
, scdoc
}:

let
  # We use harec's override of qbe until 1.2 is released, but the `qbe` argument
  # is kept to avoid breakage.
  qbe = harec.qbeUnstable;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hare";
  version = "unstable-2023-10-23";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare";
    rev = "1048620a7a25134db370bf24736efff1ffcb2483";
    hash = "sha256-slQPIhrcM+KAVAvjuRnqNdEAEr4Xa4iQNVEpI7Wl+Ks=";
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

  # Append the distribution name to the version
  env.LOCALVER = "nix";

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
    in
    ''
      runHook preConfigure

      cp config.example.mk config.mk
      makeFlagsArray+=(
        PREFIX="${builtins.placeholder "out"}"
        HARECACHE="$(mktemp -d --tmpdir harecache.XXXXXXXX)"
        BINOUT="$(mktemp -d --tmpdir bin.XXXXXXXX)"
        PLATFORM="${platform}"
        ARCH="${arch}"
      )

      runHook postConfigure
    '';

  doCheck = true;

  postFixup =
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

  strictDeps = true;
  enableParallelBuilding = true;

  meta = {
    homepage = "https://harelang.org/";
    description =
      "A systems programming language designed to be simple, stable, and robust";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "hare";
    inherit (harec.meta) platforms badPlatforms;
  };
})
