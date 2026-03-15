{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  brotli,
  libsodium,
  installShellFiles,

  # Build MySQL variant instead of PostgreSQL
  mysql ? false,
}:

let
  # Shared attributes for wal-g packages
  wal-g-common = finalAttrs: {
    version = "3.0.8";
    src = fetchFromGitHub {
      owner = "wal-g";
      repo = "wal-g";
      rev = "v${finalAttrs.version}";
      sha256 = "1ssavyxf4kv135fvfdbvgk747h7qjaanqm6sm6n5jlvz6zfw4cl8";
    };
    vendorHash = "sha256-K2J/Hi8TQs+UhudgTWsAmPUHKnwKP3cmx21CvDTjs6M=";
    nativeBuildInputs = [ installShellFiles ];
    buildInputs = [
      brotli
      libsodium
    ];

    # Enable JSON v2 experiment required by wal-g 3.0.8
    env.GOEXPERIMENT = "jsonv2";
  };

  # PostgreSQL variant (default)
  wal-g-pg = buildGoModule (
    finalAttrs:
    wal-g-common finalAttrs
    // {
      pname = "wal-g-pg";
      subPackages = [ "main/pg" ];

      ldflags = [
        "-s"
        "-w"
        "-X github.com/wal-g/wal-g/cmd/pg.walgVersion=${finalAttrs.version}"
        "-X github.com/wal-g/wal-g/cmd/pg.gitRevision=${finalAttrs.src.rev}"
      ];

      postInstall = ''
        mv $out/bin/pg $out/bin/wal-g-pg
        ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
          installShellCompletion --cmd wal-g-pg \
            --bash <($out/bin/wal-g-pg completion bash) \
            --zsh <($out/bin/wal-g-pg completion zsh)
        ''}
      '';

      meta = {
        homepage = "https://github.com/wal-g/wal-g";
        license = lib.licenses.asl20;
        description = "Archival restoration tool for PostgreSQL";
        mainProgram = "wal-g-pg";
        maintainers = [ ];
      };
    }
  );

  # MySQL variant
  wal-g-mysql = buildGoModule (
    finalAttrs:
    wal-g-common finalAttrs
    // {
      pname = "wal-g-mysql";
      subPackages = [ "main/mysql" ];

      ldflags = [
        "-s"
        "-w"
        "-X github.com/wal-g/wal-g/cmd/mysql.walgVersion=${finalAttrs.version}"
        "-X github.com/wal-g/wal-g/cmd/mysql.gitRevision=${finalAttrs.src.rev}"
      ];

      postInstall = ''
        mv $out/bin/mysql $out/bin/wal-g-mysql
        ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
          installShellCompletion --cmd wal-g-mysql \
            --bash <($out/bin/wal-g-mysql completion bash) \
            --zsh <($out/bin/wal-g-mysql completion zsh)
        ''}
      '';

      meta = {
        homepage = "https://github.com/wal-g/wal-g";
        license = lib.licenses.asl20;
        description = "Archival restoration tool for MySQL";
        mainProgram = "wal-g-mysql";
        maintainers = [ ];
      };
    }
  );

in
if mysql then wal-g-mysql else wal-g-pg
