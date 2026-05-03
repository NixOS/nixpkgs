{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  xz,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zerobrew";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "lucasgelfond";
    repo = "zerobrew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qBbH4rdpRKYxkX58ljcQMxvo4BFDdTJpvVfjrb/z3fI=";
  };

  cargoHash = "sha256-vuen++jxNB4fjAR16MN14Z0eQ9ma/SLbGPjMC/7/Ovg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
    xz
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "5-20x faster experimental Homebrew alternative";
    homepage = "https://github.com/lucasgelfond/zerobrew";
    changelog = "https://github.com/lucasgelfond/zerobrew/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      bsd2
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "zb";
  };
})
