{
  lib,
  stdenvNoCC,
  clangStdenv,
  fetchFromGitHub,
  mill,
  which,
}:

let
  # we need to lock the mill version, because an update will change the
  # fetched internal dependencies, thus breaking the deps FOD
  lockedMill = mill.overrideAttrs (oldAttrs: {
    version = "0.11.7";
    src = oldAttrs.src.overrideAttrs {
      outputHash = "sha256-iijKZlQoiIWos+Kdq9hIgiM5yM7xCf11abrJ71LO9jA=";
    };
  });
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "vyxal";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "Vyxal";
    repo = "Vyxal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R3YuXuEo3RtKsL/BJvSnmVi3U0NsRWcRBjGgGvx/C4E=";
  };

  # make sure to resolve all dependencies needed
  deps = stdenvNoCC.mkDerivation {
    name = "${finalAttrs.pname}-${finalAttrs.version}-deps";
    inherit (finalAttrs) src;

    nativeBuildInputs = [ lockedMill ];

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      export COURSIER_CACHE=$out/.coursier

      mill native.prepareOffline --all

      runHook postBuild
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-QllrP0KwdMcfo+q2hcNRt9WmHYWJqMq8scrMhnRcC/g=";
  };

  nativeBuildInputs = [
    lockedMill
    which
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    export COURSIER_CACHE=${finalAttrs.deps}/.coursier

    mill native.nativeLink

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 out/native/nativeLink.dest/out $out/bin/vyxal
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/Vyxal/Vyxal/releases/tag/${finalAttrs.src.rev}";
    description = "A code-golfing language that has aspects of traditional programming languages";
    homepage = "https://github.com/Vyxal/Vyxal";
    license = lib.licenses.mit;
    mainProgram = "vyxal";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
