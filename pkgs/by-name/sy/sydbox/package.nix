{
  lib,
  fetchFromGitLab,
  libseccomp,
  mandoc,
  nix-update-script,
  pkg-config,
  rustPlatform,
  scdoc,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sydbox";
  version = "3.40.1";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.exherbo.org";
    owner = "Sydbox";
    repo = "sydbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hO17Rm4gOSCVlmVZTZdJ2qh9pzdrl8Ay9uU6w7V4RPo=";
  };

  cargoHash = "sha256-y6FvIH3+daDsYP18BpsoYKsshvpVcSU7s/tjPdnudtY=";

  nativeBuildInputs = [
    mandoc
    pkg-config
    scdoc
  ];

  buildInputs = [ libseccomp ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  checkFlags = [
    # rm -rf tmpdir: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    "--skip=fs::tests::test_relative_symlink_resolution"
    # Failed to write C source file!: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }
    "--skip=proc::tests::test_proc_set_at_secure_test_32bit_dynamic"
    # Flakey. May only fail on OfBorg/Hydra
    # Failed to write C source file!: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }
    "proc::tests::test_proc_set_at_secure_test_32bit_static"
    # Failed to write C source file!: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }
    "--skip=proc::tests::test_proc_set_at_secure_test_32bit_static_pie"
    # /bin/false: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    "--skip=syd_test"

    # Endlessly stall or use "invalid arguments". Maybe a sandbox issue?
    "--skip=caps"
    "--skip=landlock"
    "--skip=proc::proc_cmdline"
    "--skip=proc::proc_comm"
  ];

  # TODO: Have these directories be created upstream similar to the vim files
  postInstall = ''
    mkdir -p $out/share/man/man{1,2,5,7}

    make $makeFlags install-{man,vim}
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "syd -V";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Seccomp-based application sandbox";
    homepage = "https://gitlab.exherbo.org/sydbox/sydbox";
    changelog = "https://gitlab.exherbo.org/sydbox/sydbox/-/blob/${finalAttrs.src.tag}/ChangeLog.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mvs
      getchoo
    ];
    mainProgram = "syd";
    platforms = lib.platforms.linux;
  };
})
