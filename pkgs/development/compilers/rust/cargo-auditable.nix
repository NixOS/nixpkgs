{
  lib,
  buildPackages,
  fetchFromGitHub,
  makeRustPlatform,
  installShellFiles,
  stdenv,
}:

let
  rustPlatform = makeRustPlatform {
    inherit (buildPackages) rustc;
    cargo = buildPackages.cargo.override {
      auditable = false;
    };
  };

  auditableBuilder = lib.extendMkDerivation {
    constructDrv = rustPlatform.buildRustPackage.override { cargo-auditable = bootstrap; };

    extendDrvArgs =
      finalAttrs:
      {
        pname ? "cargo-auditable",
        auditable ? true,
        ...
      }:
      {
        inherit auditable pname;
        version = "0.6.5";

        src = fetchFromGitHub {
          owner = "rust-secure-code";
          repo = "cargo-auditable";
          tag = "v${finalAttrs.version}";
          hash = "sha256-zjv2/qZM0vRyz45DeKRtPHaamv2iLtjpSedVTEXeDr8=";
        };

        cargoHash = "sha256-oTPGmoGlNfPVZ6qha/oXyPJp94fT2cNlVggbIGHf2bc=";

        nativeBuildInputs = [
          installShellFiles
        ];

        checkFlags = [
          # requires wasm32-unknown-unknown target
          "--skip=test_wasm"
        ]
        ++ lib.optionals (!auditable) [
          "--skip=test_proc_macro"
          "--skip=test_self_hosting"
        ];

        postInstall = ''
          installManPage cargo-auditable/cargo-auditable.1
        '';

        passthru = {
          inherit bootstrap;
        };

        meta = {
          description = "Tool to make production Rust binaries auditable";
          mainProgram = "cargo-auditable";
          homepage = "https://github.com/rust-secure-code/cargo-auditable";
          changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${finalAttrs.version}/cargo-auditable/CHANGELOG.md";
          license = with lib.licenses; [
            mit # or
            asl20
          ];
          maintainers = with lib.maintainers; [ RossSmyth ];
          broken = stdenv.hostPlatform != stdenv.buildPlatform;
        };
      };
  };

  # cargo-auditable cannot be built with cargo-auditable until cargo-auditable is built
  bootstrap = auditableBuilder {
    pname = "cargo-auditable-bootstrap";
    auditable = false;
  };
in
auditableBuilder {
  auditable = true;
}
