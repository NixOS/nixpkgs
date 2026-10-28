{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildPackages,
  stdenv,
  testers,
  versionCheckHook,
  rustc,
  cacert,
  pkg-config,
  openssl,
  cargo-c,
  validatePkgConfig,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "upki";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "upki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rEGFhMWnFOBSaWpEY9/HJGxJK7OSAb+yPNWuNgTJ768=";
  };

  cargoHash = "sha256-5eecMFTVq1scGAw9DEXEYz/89Qe9dVBymyJmKgYfoqg=";

  cargoBuildFlags = [
    "--package=upki-cli"
    "--package=upki-openssl"
  ];

  cargoInstallFlags = [
    "--package=upki-cli"
  ];

  nativeBuildInputs = [
    cargo-c
    pkg-config
  ];
  buildInputs = [ openssl ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  postBuild = ''
    ${buildPackages.rust.envVars.setEnv} cargo cbuild --release --frozen \
      --package=upki \
      --prefix=$out \
      --target=${stdenv.hostPlatform.rust.rustcTarget}
    ${buildPackages.rust.envVars.setEnv} cargo cbuild --release --frozen \
      --package=upki-openssl \
      --prefix=$out \
      --target=${stdenv.hostPlatform.rust.rustcTarget}
  '';

  preCheck = ''
    # fetch_with_stale_local_manifest sets its local cache mtime to 1970-01-02.
    # Make the server fixture newer than that cache.
    touch -d @172800 upki-cli/tests/data/typical/revocation/manifest.json
  '';

  postInstall = ''
    ${buildPackages.rust.envVars.setEnv} cargo cinstall --release --frozen \
      --package=upki \
      --prefix=$out \
      --target=${stdenv.hostPlatform.rust.rustcTarget}
    ${buildPackages.rust.envVars.setEnv} cargo cinstall --release --frozen \
      --package=upki-openssl \
      --prefix=$out \
      --target=${stdenv.hostPlatform.rust.rustcTarget}
    cp $out/include/upki/upki.h $out/include/upki_openssl/upki.h
  '';

  nativeInstallCheckInputs = [
    pkg-config
    versionCheckHook
    validatePkgConfig
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=unstable" ];
    };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Platform-independent browser-grade certificate infrastructure";
    homepage = "https://github.com/rustls/upki";
    changelog = "https://github.com/rustls/upki/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [
      lib.maintainers.skyesoss
      lib.maintainers.cpu
    ];
    mainProgram = "upki";
    pkgConfigModules = [
      "upki"
      "upki_openssl"
    ];
    platforms = rustc.meta.platforms;
  };
})
