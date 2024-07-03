{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
  testers,
  talecast
}:

rustPlatform.buildRustPackage rec {
  pname = "talecast";
  version = "0.1.39";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RwB+X+i3CEcTyKac81he9/cT2aQ4M7AqgqSDBEvhFJU=";
  };

  cargoHash = "sha256-mIzrYlAqHYrK2bb/ZUzqIwhPJKcTQpNpqijpEuwLc5A=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = talecast; };
  };

  meta = {
    description = "Simple CLI podcatcher";
    homepage = "https://github.com/TBS1996/TaleCast";
    license = lib.licenses.mit;
    mainProgram = "talecast";
    maintainers = with lib.maintainers; [ confusedalex getchoo ];
  };
}
