{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  brotli,
  libsodium,
  installShellFiles,
}:

buildGoModule rec {
  pname = "wal-g";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    rev = "v${version}";
    sha256 = "sha256-kUn1pJEdGec+WIZivqVAhELoBTKOF4E07Ovn795DgIY=";
  };

  vendorHash = "sha256-TwYl3B/VS24clUv1ge/RroULIY/04xTxc11qPNGhnfs=";

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
    "-X github.com/wal-g/wal-g/cmd/pg.walgVersion=${version}"
    "-X github.com/wal-g/wal-g/cmd/pg.gitRevision=${src.rev}"
  ];

  postInstall = ''
    mv $out/bin/pg $out/bin/wal-g
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wal-g \
      --bash <($out/bin/wal-g completion bash) \
      --zsh <($out/bin/wal-g completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/wal-g/wal-g";
    license = licenses.asl20;
    description = "Archival restoration tool for PostgreSQL";
    mainProgram = "wal-g";
    maintainers = [ ];
  };
}
