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
  useFetchCargoVendor = true;
  cargoHash = "sha256-P/NYyoH/9kkyBwCGORK9bxEjyye12SP3hRDnL9c6i78=";
  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];
  buildInputs = [ openssl ];

  RUSTC_BOOTSTRAP = 1;

  doInstallCheck = true;

  meta = {
    description = "Syndicate broker server";
    homepage = "https://synit.org/";
    license = lib.licenses.asl20;
    mainProgram = "syndicate-server";
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };
}
