{ lib
, rustPlatform
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

let
  # Keep the vscode "mgt19937.typst-preview" extension in sync when updating
  # this package at pkgs/applications/editors/vscode/extensions/default.nix
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typst-preview";
    rev = "v${version}";
    hash = "sha256-N4PK9RucuOwminikayXq9aqK9l6T6v9a6tcksMllKdM=";
    fetchSubmodules = true;

    postFetch = ''
      cd $out
      substituteInPlace addons/frontend/yarn.lock \
        --replace-fail '"typst-dom@link:../typst-dom"' '"typst-dom@file:../typst-dom"'
    '';
  };

  frontendSrc = "${src}/addons/frontend";
  domSrc = "${src}/addons/typst-dom";

  typst-dom = mkYarnPackage {
    inherit version;
    pname = "typst-dom";
    src = domSrc;
    packageJSON = ./dom.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${domSrc}/yarn.lock";
      hash = "sha256-XAVxUKf2XJCOUkAT+tTefAk8myGismhz1aOHosZA+d4=";
    };

    buildPhase = ''
      runHook preBuild
      yarn --offline build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -R deps/typst-dom $out
      runHook postInstall
    '';

    doDist = false;
  };

  frontend = mkYarnPackage {
    inherit version;
    pname = "typst-preview-frontend";
    src = frontendSrc;
    packageJSON = ./frontend.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${frontendSrc}/yarn.lock";
      hash = "sha256-jZZG8omzwrustcrdVb42nypu6JKXPW/fJn26NUrc/ZA=";
    };

    packageResolutions = { inherit typst-dom; };

    buildPhase = ''
      runHook preBuild
      yarn --offline build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -R deps/typst-preview-frontend/dist $out
      runHook postInstall
    '';

    doDist = false;
  };

in
rustPlatform.buildRustPackage {
  pname = "typst-preview";
  inherit version src;

  cargoHash = "sha256-JDUHESH0aFIlXX61IxOXNSaTlFCgo3hFRbfoQWWq6e0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  prePatch = ''
    mkdir -p addons/vscode/out/frontend
    cp -R ${frontend}/* addons/vscode/out/frontend/
    cp -R ${frontend}/index.html ./src/index.html
  '';

  meta = {
    description = "Typst preview extension for VSCode";
    homepage = "https://github.com/Enter-tainer/typst-preview/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ berberman ];
    mainProgram = "typst-preview";
  };
}
