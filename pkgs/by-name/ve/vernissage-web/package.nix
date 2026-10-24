{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  angular-cli,
  dart-sass,
  nodejs,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "vernissage-web";
  version = "1.44.0";

  src = fetchFromGitHub {
    owner = "VernissageApp";
    repo = "VernissageWeb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UQQdWBrUKgrWLICkL3tb8dlWGNJXIaVTnKKQ3mDaPbY=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      commit=$(git rev-parse --short HEAD) && sed -i -e "s/buildx/$commit/g" src/environments/environment.ts
    '';
  };
  npmDepsHash = "sha256-UKhI4QDtGMtbrATN9EsGugepHcc/bRxoqX1R88htnzU=";

  strictDeps = true;

  nativeBuildInputs = [
    angular-cli
    dart-sass
  ];

  # sass-embedded's bundled Dart compiler won't run in the sandbox; use nixpkgs' dart-sass.
  # https://github.com/sass/embedded-host-node/issues/334
  preBuild = ''
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["dart-sass"];'
  '';

  buildInputs = [ angular-cli ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R dist $out/dist

    makeWrapper ${nodejs}/bin/node $out/bin/VernissageWeb \
      --add-flags "$out/dist/VernissageWeb/server/server.mjs"

    runHook postInstall
  '';

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vernissage web frontend";
    homepage = "https://github.com/VernissageApp/VernissageWeb";
    changelog = "https://github.com/VernissageApp/VernissageWeb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "VernissageWeb";
  };
})
