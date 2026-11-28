{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  brotli,
  libsodium,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "wal-g";
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

  subPackages = [ "main/pg" ];

  tags = [
    "brotli"
    "libsodium"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/wal-g/wal-g/cmd/pg.walgVersion=${finalAttrs.version}"
    "-X github.com/wal-g/wal-g/cmd/pg.gitRevision=${finalAttrs.src.rev}"
  ];

  postInstall = ''
    mv $out/bin/pg $out/bin/wal-g
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wal-g \
      --bash <($out/bin/wal-g completion bash) \
      --zsh <($out/bin/wal-g completion zsh)
  '';

  meta = {
    homepage = "https://github.com/wal-g/wal-g";
    license = lib.licenses.asl20;
    description = "Archival restoration tool for PostgreSQL";
    mainProgram = "wal-g";
    maintainers = [ ];
  };
})
