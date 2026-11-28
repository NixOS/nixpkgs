{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  brotli,
  libsodium,
  installShellFiles,

  # Database variant to build, either "pg" or "mysql"
  variant ? "pg",
}:

let
  database =
    {
      pg = "PostgreSQL";
      mysql = "MySQL";
    }
    .${variant};
in
buildGoModule (finalAttrs: {
  pname = "wal-g-${variant}";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "wal-g";
    repo = "wal-g";
    tag = "v${finalAttrs.version}";
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

  __structuredAttrs = true;

  subPackages = [ "main/${variant}" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/wal-g/wal-g/cmd/${variant}.walgVersion=${finalAttrs.version}"
    "-X github.com/wal-g/wal-g/cmd/${variant}.gitRevision=${finalAttrs.src.rev}"
  ];

  postInstall = ''
    mv $out/bin/${variant} $out/bin/${finalAttrs.pname}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.pname} \
      --bash <($out/bin/${finalAttrs.pname} completion bash) \
      --zsh <($out/bin/${finalAttrs.pname} completion zsh)
  '';

  meta = {
    homepage = "https://github.com/wal-g/wal-g";
    license = lib.licenses.asl20;
    description = "Archival restoration tool for ${database}";
    mainProgram = finalAttrs.pname;
    maintainers = [ ];
  };
})
