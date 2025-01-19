{
  fetchFromGitHub,
  lib,
  nodejs,
  stdenv,
  testers,
  yarn,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yarn-berry";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "yarnpkg";
    repo = "berry";
    rev = "@yarnpkg/cli/${finalAttrs.version}";
    hash = "sha256-POo/VPKC4mPZD73WUJOn5b7fo3ya41ic64iRCscjQ3w=";
  };

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [
    yarn
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    yarn workspace @yarnpkg/cli build:cli
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm 755 ./packages/yarnpkg-cli/bundles/yarn.js "$out/bin/yarn"
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://yarnpkg.com/";
    description = "Fast, reliable, and secure dependency management";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      ryota-ka
      pyrox0
      DimitarNestorov
    ];
    platforms = lib.platforms.unix;
    mainProgram = "yarn";
  };
})
