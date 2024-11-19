{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zt4uXkO6Y0Yc1Wt8l5O79oKbgNLrgip40ftD7UfUPwo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-FQ35K2K+lfQU123GIOlHbPPLLIpvZqvDMFirNbYMl2A=";

  cargoBuildFlags = [
    "-p"
    "topiary-cli"
  ];
  cargoTestFlags = cargoBuildFlags;

  env.TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/queries";

  postInstall = ''
    install -Dm444 queries/* -t $out/share/queries
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    mainProgram = "topiary";
    homepage = "https://github.com/tweag/topiary";
    changelog = "https://github.com/tweag/topiary/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
