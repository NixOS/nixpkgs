{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  withBubblewrap ? stdenv.isLinux,
  makeBinaryWrapper,
  xz,
  zstd,
  writableTmpDirAsHomeHook,
  bubblewrap,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unnix";
  version = "0.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = "unnix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZmCagknLEJlAtoVfHrQZeb3CbxpT37J6Mvyxn/qQRmQ=";
  };

  cargoHash = "sha256-NXyB1Ic2EnLJPpFDn1idb5WYfS8gXzgvIRbQoJ3bsS8=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ]
  ++ lib.optionals withBubblewrap [
    makeBinaryWrapper
  ];

  buildInputs = [
    xz
    zstd
  ];

  # tests try to access ~/.cache/unnix
  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  env = {
    GENERATE_ARTIFACTS = "artifacts";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/unnix.{bash,fish} --zsh artifacts/_unnix
  ''
  + lib.optionalString withBubblewrap ''
    wrapProgram $out/bin/unnix \
      --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
  '';

  meta = {
    description = "Reproducible Nix environments without installing Nix";
    homepage = "https://github.com/figsoda/unnix";
    changelog = "https://github.com/figsoda/unnix/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "unnix";
  };
})
