{
  lib,
  fetchFromGitHub,
  gitMinimal,
  jq,
  nix-update-script,
  runCommand,
  rustPlatform,
  versionCheckHook,
  stdenv,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yarn-zpm";
  version = "6.0.0-rc.23";

  src = fetchFromGitHub {
    owner = "yarnpkg";
    repo = "zpm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-db6uqSBfzr55eLYYf95krHjA47MycnjZVJ2a82Q/Dbw=";
  };

  cargoHash = "sha256-f/GSG4cqwT8z6Uj7XCl2rN1ZI7Q9DGTDUQ8/pMG+suI=";

  cargoBuildFlags = [ "--package=zpm" ];
  cargoTestFlags = [ "--package=zpm" ];

  env = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=http::tests::network_concurrency_permit_is_released_after_failure"
    "--skip=http::tests::network_concurrency_limits_in_flight_response_bodies"
  ];

  # yarn is the Yarn Switch binary (zpm-switch package), yarn-bin is the actual package manager (zpm package)
  # See https://yarn6.netlify.app/getting-started/#:~:text=You%20can%20bypass%20Yarn%20Switch
  postInstall = ''
    mv $out/bin/yarn-bin $out/bin/yarn
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      simple-test =
        runCommand "yarn-zpm-simple-test"
          {
            env = finalAttrs.env;
            nativeBuildInputs = [
              jq
              gitMinimal
              finalAttrs.finalPackage
            ];
          }
          ''
            export HOME=$(mktemp -d)
            git config --global user.name nixbld
            git config --global user.email nixbld@localhost
            cat > .yarnrc.yml <<EOF
            nodeLinker: node-modules
            EOF
            yarn init
            jq -e '.packageManager == "yarn@${finalAttrs.finalPackage.version}.local"' package.json
            jq '. + {workspaces: ["workspace-test"]}' package.json > package.json.tmp
            mv package.json.tmp package.json
            mkdir workspace-test
            jq -n '{name: "workspace-test"}' > workspace-test/package.json
            yarn install
            jq -e '.name == "workspace-test"' node_modules/workspace-test/package.json
            jq -e '.entries | has("workspace-test@workspace:^")' yarn.lock
            touch $out
          '';
    };
  };

  meta = {
    description = "Yarn is an open-source package manager for JavaScript and TypeScript projects";
    homepage = "https://yarn6.netlify.app";
    changelog = "https://github.com/yarnpkg/zpm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    mainProgram = "yarn";
  };
})
