{
  lib,
  stdenv,
  fetchFromGitHub,
  go,
  ncurses,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "syzkaller";
  version = "0-unstable-2024-01-09";

  src = fetchFromGitHub {
    owner = "google";
    repo = "syzkaller";
    rev = "67d7ec0a69193b2acbb8cdb5109d5505a9128ac5";
    hash = "sha256-hXYyomTPR7T2zJi49xylQdEXALYV6IbNXdHZo/JHqz8=";
  };

  nativeBuildInputs = [
    go
    ncurses
  ];

  postPatch =
    let
      commitDate = lib.concatStringsSep "" (
        builtins.tail (lib.splitString "-" (lib.removePrefix "0-" finalAttrs.version))
      );
      dateString = "${commitDate}-133700"; # commit date + dummy time
    in
    ''
      substituteInPlace Makefile \
        --replace-fail '$(shell git rev-parse HEAD)' '${finalAttrs.src.rev}' \
        --replace-fail '$(shell git diff --shortstat)' "" \
        --replace-fail '$(shell git log -n 1 --format="%cd" --date=format:%Y%m%d-%H%M%S)' '${dateString}' \
        --replace-fail './bin' "$out/bin"
    '';

  configurePhase = ''
    runHook preConfigure

    mkdir -p $out/bin

    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"

    runHook postConfigure
  '';

  dontInstall = true;

  meta = {
    description = "Unsupervised, coverage-guided kernel fuzzer";
    homepage = "https://github.com/google/syzkaller";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.msanft ];
    platforms = lib.platforms.linux;
    mainProgram = "syz-manager";
  };
})
