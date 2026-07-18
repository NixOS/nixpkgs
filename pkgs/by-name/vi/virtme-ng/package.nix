{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  cargo,
  rustc,
  installShellFiles,
  makeWrapper,
  qemu,
  virtiofsd,
  busybox,
  socat,
  openssh,
  kmod,
  file,
  glibc,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "virtme-ng";
  version = "1.41";
  pyproject = true;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "arighi";
    repo = "virtme-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/R+2ND/N+exF9eDSxAN8LR3cDuxBvpGSkiXcckyq8TY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    cargoRoot = "virtme_ng_init";
    hash = "sha256-KpVGrhOCsgLD7vH3NGEtgaH/tcVOisVyXDKjJ+4hxgM=";
  };

  cargoRoot = "virtme_ng_init";

  # NixOS-support fixes, merged upstream in arighi/virtme-ng#480 but not yet in a
  # release; drop once a release includes them. The README hunk is excluded (it
  # doesn't apply to v1.41 and the README isn't installed anyway).
  patches = [
    (fetchpatch {
      name = "nixos-support-pr480.patch";
      url = "https://github.com/arighi/virtme-ng/commit/bd434224876a071f9c0a4619c82c158ff9a07150.patch";
      excludes = [ "README.md" ];
      hash = "sha256-YPnm+IC185pxrkpuZPLcoTTQq47EoTxLNgYmXsitTfA=";
    })
  ];

  postPatch = ''
    # data_files installs the bash completions and man page under absolute /usr
    # paths; drop it and install them into the store layout in postInstall.
    substituteInPlace setup.py \
      --replace-fail "data_files=data_files," ""
  '';

  env.BUILD_VIRTME_NG_INIT = 1;

  build-system = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ]
  ++ (with python3Packages; [
    setuptools
    argparse-manpage
  ]);

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # setup.py builds virtme-ng-init with `-C target-feature=+crt-static`
  buildInputs = [ glibc.static ];

  dependencies = with python3Packages; [
    argcomplete
    requests
    # Required by the bundled vng-mcp (Model Context Protocol) server.
    mcp
    anyio
  ];

  # Provide the host tools virtme-ng shells out to (qemu, virtiofsd, busybox,
  # etc.) as a PATH *suffix*: `vng --build` compiles the kernel on the host and
  # must use the user's GNU coreutils/diff/find, not shadow them with busybox.
  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [
      qemu
      virtiofsd
      busybox
      socat
      openssh
      kmod
      file
      glibc.bin # getent
    ])
  ];

  doCheck = false;

  pythonImportsCheck = [
    "virtme_ng"
    "virtme_ng.mcp"
  ];

  postInstall = ''
    installShellCompletion --cmd vng --bash vng-prompt
    installShellCompletion --cmd virtme-ng --bash virtme-ng-prompt
  '';

  meta = {
    description = "Quickly build and run kernels inside a virtualized snapshot of your live system";
    homepage = "https://github.com/arighi/virtme-ng";
    changelog = "https://github.com/arighi/virtme-ng/releases/tag/v${finalAttrs.version}";
    # virtme-ng is GPL-2.0-only; the virtme-ng-init guest helper is GPL-3.0-only
    # and statically links Rust crates under MIT and MIT OR Apache-2.0.
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      mit
      asl20
    ];
    mainProgram = "vng";
    maintainers = [ lib.maintainers.nikableh ];
    platforms = lib.platforms.linux;
  };
})
