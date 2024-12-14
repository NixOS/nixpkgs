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
  version = "0.48.0";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "syndicate-lang";
    repo = "syndicate-rs";
    rev = "${pname}-v${version}";
    hash = "sha256-DVgFlJCqaTmQ7eL2LQ8rkIbvaEfwx+NDeXRA8qB+/Qo=";
  };
  cargoHash = "sha256-eSzRKTUDkx0i2z5y5rm1A799CfLPqd+txpmbolqe+PQ=";
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
