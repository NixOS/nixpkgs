{
  fetchFromGitHub,
  lib,
  nodejs,
  stdenv,
  testers,
  yarn,
  callPackage,
  berryVersion ? 4,
}:

let
  version_4 = "4.10.3";
  version_3 = "3.8.7";
  hash_4 = "sha256-sPA9XxWuYvxw/eYAsePuHOaaY2jIBRAv5YfDgVUF6YY=";
  hash_3 = "sha256-vRrk+Fs/7dZha3h7yI5NpMfd1xezesnigpFgTRCACZo=";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "yarn-berry";
  version = if berryVersion == 4 then version_4 else version_3;

  src = fetchFromGitHub {
    owner = "yarnpkg";
    repo = "berry";
    tag = "@yarnpkg/cli/${finalAttrs.version}";
    hash = if berryVersion == 4 then hash_4 else hash_3;
  };

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [
    nodejs
    yarn
  ];

  strictDeps = true;

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

  passthru = {
    updateScript = ./update.sh;

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
  }
  // (callPackage ./fetcher { yarn-berry = finalAttrs; });

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
