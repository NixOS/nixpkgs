{ lib
, stdenvNoCC
, clangStdenv
, fetchFromGitHub
, mill
, which
}:

let
  pname = "vyxal";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "Vyxal";
    repo = "Vyxal";
    rev = "v${version}";
    hash = "sha256-DQKNKH5unvbyJLsNERTuAo7Bc7YQKmeydGQkEU3OebI=";
  };

  # make sure to resolve all dependencies needed
  deps = stdenvNoCC.mkDerivation {
    name = "${pname}-${version}-deps";
    inherit src;

    nativeBuildInputs = [ mill ];

    buildPhase = ''
      runHook preBuild
      export HOME=$(mktemp -d)
      export COURSIER_CACHE=$out/.coursier
      mill native.prepareOffline --all
      runHook postBuild
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    # Sadly, this hash will break every time `mill` gets an update
    outputHash = "sha256-Nhr54Fh8RIxHZ5G8KK34zgwFA4XB81tjhfzEAVCTxOM=";
  };
in
clangStdenv.mkDerivation {
  inherit pname version src deps;

  nativeBuildInputs = [ mill which ];

  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)
    export COURSIER_CACHE=${deps}/.coursier
    mill native.nativeLink
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 out/native/nativeLink.dest/out $out/bin/vyxal
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/Vyxal/Vyxal/releases/tag/${src.rev}";
    description = "A code-golfing language that has aspects of traditional programming languages";
    homepage = "https://github.com/Vyxal/Vyxal";
    license = lib.licenses.mit;
    mainProgram = "vyxal";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
}
