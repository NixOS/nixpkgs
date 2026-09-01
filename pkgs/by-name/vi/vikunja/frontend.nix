{
  src,
  version,

  lib,
  stdenv,
  nodejs_24,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  dart-sass,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vikunja-frontend";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/frontend";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-aQWTzJZU6NJrZxuoCeQDJjujPq+niixmFvqtPdWS4wk=";
  };

  nativeBuildInputs = [
    nodejs_24
    dart-sass
    pnpmConfigHook
    pnpm_10
  ];

  postPatch = ''
    substituteInPlace src/version.json \
      --replace-fail '"dev"' '"${finalAttrs.version}"'
  '';

  doCheck = true;

  postBuild = ''
    # Force sass-embedded to use our dart-sass instead of bundled binaries.
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
    pnpm run build
  '';

  checkPhase = ''
    pnpm run test:unit --run
  '';

  installPhase = ''
    cp -r dist/ $out
  '';
})
