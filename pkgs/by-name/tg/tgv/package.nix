{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tgv";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "zeqianli";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-/oMnuSzFzJhYaNwVHI2qyNSBYB/3bRjBHS7dq6QLCs8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-4yF5xaqMF9wMFRtTw33KjTH9V4rU7eCXT+HVtSBl7hE=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Explore genomes in the terminal.";
    homepage = "https://github.com/zeqianli/tgv";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.idlip ];
  };
})
