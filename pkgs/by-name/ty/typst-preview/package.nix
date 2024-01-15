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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Enter-tainer";
    repo = "typst-preview";
    rev = "v${version}";
    hash = "sha256-P11Nkn9Md5xsB9Z7v9O+CRvP18vPEC0Y973Or7i0y/4=";
  };

  frontendSrc = "${src}/addons/frontend";

  frontend = mkYarnPackage {
    inherit version;
    pname = "typst-preview-frontend";
    src = frontendSrc;
    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${frontendSrc}/yarn.lock";
      hash = "sha256-7a7/UOfau84nLIAKj6Tn9rTUmeBJ7rYDFAdr55ZDLgA=";
    };

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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hayagriva-0.4.0" = "sha256-377lXL3+TO8U91OopMYEI0NrWWwzy6+O7B65bLhP+X4=";
      "typst-0.9.0" = "sha256-+rnsUSGi3QZlbC4i8racsM4U6+l8oA9YjjUOtQAIWOk=";
      "typst-ts-compiler-0.4.0-rc9" = "sha256-NVmbAodDRJBJlGGDRjaEcTHGoCeN4hNjIynIDKqvNbM=";
    };
  };

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
  '';

  meta = {
    description = "Typst preview extension for VSCode";
    homepage = "https://github.com/Enter-tainer/typst-preview/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ berberman ];
    mainProgram = "typst-preview";
  };
}
