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
  version = "0.46.0";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "syndicate-lang";
    repo = "syndicate-rs";
    rev = "${pname}-v${version}";
    sha256 = "sha256-bTteZIlBSoQ1o5shgd9NeKVvEhZTyG3i2zbeVojWiO8=";
  };
  cargoHash = "sha256-SIpdFXTk6MC/drjCLaaa49BbGsvCMNbPGCfTxAlCo9c=";
  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];
  buildInputs = [ openssl ];

  RUSTC_BOOTSTRAP = 1;

  doInstallCheck = true;

  meta = {
    description = "Syndicate broker server";
    homepage = "http://synit.org/";
    license = lib.licenses.asl20;
    mainProgram = "syndicate-server";
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };
}
