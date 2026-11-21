{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  brotli,
  libsodium,
  installShellFiles,

  # Build the MySQL variant instead of the PostgreSQL one
  mysql ? false,
}:

let
  # Attributes shared by all wal-g variants
  wal-g-common = finalAttrs: {
    version = "3.0.9";

    src = fetchFromGitHub {
      owner = "wal-g";
      repo = "wal-g";
      rev = "v${finalAttrs.version}";
      sha256 = "sha256-QTPgJuCuLxlBqa2QAhV91qX4XTQHIvzAQDntchGpxrQ=";
    };

    vendorHash = "sha256-Emk6H+nd22/hE/BXwchtz1xD35KztJ8yBeE28jqzTMA=";

    nativeBuildInputs = [ installShellFiles ];

    buildInputs = [
      brotli
      libsodium
    ];

    tags = [
      "brotli"
      "libsodium"
    ];

    # wal-g uses the encoding/json/v2 package, which is still gated behind a
    # Go build experiment.
    env.GOEXPERIMENT = "jsonv2";
  };

  # PostgreSQL variant (default)
  wal-g-pg = buildGoModule (
    finalAttrs:
    wal-g-common finalAttrs
    // {
      pname = "wal-g-pg";

      __structuredAttrs = true;

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

      __structuredAttrs = true;

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
