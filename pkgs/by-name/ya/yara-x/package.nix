{
  lib,
  rust,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  cargo-c,
  testers,
  yara-x,
}:

rustPlatform.buildRustPackage rec {
  pname = "yara-x";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara-x";
    tag = "v${version}";
    hash = "sha256-ZSJHvpRZO6Tbw7Ct4oD6QmuV4mJ4RGW5gnT6PTX+nC8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pD4qyw+TTpmcoX1N3C65VelYszYifm9sFOsEkXEysvo=";

  nativeBuildInputs = [
    installShellFiles
    cargo-c
  ];

  postBuild = ''
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall =
    ''
      ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd yr \
        --bash <($out/bin/yr completion bash) \
        --fish <($out/bin/yr completion fish) \
        --zsh <($out/bin/yr completion zsh)
    '';

  passthru.tests.version = testers.testVersion {
    package = yara-x;
  };

  meta = {
    description = "Tool to do pattern matching for malware research";
    homepage = "https://virustotal.github.io/yara-x/";
    changelog = "https://github.com/VirusTotal/yara-x/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fab
      lesuisse
    ];
    mainProgram = "yr";
  };
}
