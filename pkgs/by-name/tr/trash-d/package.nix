{
  lib,
  stdenv,
  fetchFromGitHub,
  dub,
  installShellFiles,
  just,
  ldc,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "trash-d";
  version = "20";

  src = fetchFromGitHub {
    owner = "rushsteve1";
    repo = "trash-d";
    tag = version;
    hash = "sha256-x76kEqgwJGW4wmEyr3XzEXZ2AvRsm9ewrfjRjIsOphw=";
  };

  preConfigure = ''
    # dub needs a writable home
    export DUB_HOME=$(mktemp -d)

    # don't compile as static binary
    substituteInPlace dub.json \
      --replace-fail '["-static"]' '[]'

    # configure the default task for `just`
    substituteInPlace Justfile \
      --replace-fail '@just --list' '@just all'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    dub
    installShellFiles
    just
    ldc
    scdoc
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 build/trash -t "$out/bin"
    installManPage build/trash.1

    runHook postInstall
  '';

  meta = {
    description = "Near drop-in replacement for rm that uses the trash bin";
    homepage = "https://github.com/rushsteve1/trash-d/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "trash";
    platforms = lib.platforms.unix;
  };
}
