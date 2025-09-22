{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "syndicate-server";
  version = "0.50.1";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "syndicate-lang";
    repo = "syndicate-rs";
    rev = "${pname}-v${version}";
    hash = "sha256-orQN83DE+ZNgdx2PVcYrte/rVDFFtuQuRDKzeumpsLo=";
  };

  cargoHash = "sha256-lR36UAMedPdfvX613adxxRzJe+Ri09hiZYanyu7xbLU=";
  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];
  buildInputs = [ openssl ];

  RUSTC_BOOTSTRAP = 1;

  doCheck = false;
  doInstallCheck = true;

  meta = {
    description = "Syndicate broker server";
    homepage = "https://synit.org/";
    license = lib.licenses.asl20;
    mainProgram = "syndicate-server";
    platforms = lib.platforms.linux;
  };
}
