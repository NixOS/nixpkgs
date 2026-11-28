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
  aws-lc,
  openssl,
  cargo-c,
  validatePkgConfig,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "upki";
  version = "1.0.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "upki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pFrk/TcJ6AjqZ8NbyIdF5e+wesl8TXEUPsNCigKPJ3M=";
  };

  cargoHash = "sha256-vCiZTh5Xd/0EXhOlPn+CeqxX7flt4IehPL1NqUmWCyY=";

  cargoBuildFlags = [
    "--package=upki-cli"
    "--package=upki-openssl"
  ];

  cargoInstallFlags = [
    "--package=upki-cli"
  ];

  nativeCheckInputs = [ cacert ];

  nativeBuildInputs = [
    cargo-c
    pkg-config
  ];
  buildInputs = [
    aws-lc
    openssl
  ];

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

  # These upstream packaging tests require systemd tools and we aren't
  # using the checked systemd units at this time.
  checkFlags = [
    "--skip=systemd_units_verify"
    "--skip=sysusers_configuration_verifies"
  ];

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
