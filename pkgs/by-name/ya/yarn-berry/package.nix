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
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "yarnpkg";
    repo = "berry";
    tag = "@yarnpkg/cli/${finalAttrs.version}";
    hash = "sha256-cNgR0t780/LJA+IIwycro/7AQjWa1tn00bh4ucPjVEc=";
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

  meta = with lib; {
    homepage = "https://yarnpkg.com/";
    changelog = "https://github.com/yarnpkg/berry/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, reliable, and secure dependency management";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      ryota-ka
      pyrox0
      DimitarNestorov
    ];
    platforms = platforms.unix;
    mainProgram = "yarn";
  };
})
