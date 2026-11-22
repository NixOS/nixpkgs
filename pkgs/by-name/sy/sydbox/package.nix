{
  lib,
  fetchFromGitLab,
  libseccomp,
  mandoc,
  nix-update-script,
  pkg-config,
  rustPlatform,
  scdoc,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sydbox";
  version = "3.59.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.exherbo.org";
    owner = "Sydbox";
    repo = "sydbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2hpLvclVjl42TKN3rt5w9MgoQigOpluNQaYSjbVyujY=";
  };

  cargoHash = "sha256-T0LiEiKIMVylTn6gDtd5zHVz9DLzqBBZ+wTo9bwLlt8=";

  nativeBuildInputs = [
    mandoc
    pkg-config
    scdoc
  ];

  buildInputs = [ libseccomp ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  checkFlags = [
    "--exact"

    # /bin/false: Os { code: 2, kind: NotFound, message: "No such file or directory" }
    "--skip=syd_test"

    # No block devices in /dev in the build sandbox
    "--skip=fd::tests::test_fd_name_8"

    # Fail without the build sandbox, e.g. with daemonless Nix in a container
    # memfd_secret(2) may fail with EACCES depending on the host, only ENOSYS is expected
    "--skip=fd::tests::test_fd_name_4"
    "--skip=sealbox::tests::test_secret_box_1"
    "--skip=sealbox::tests::test_secret_box_2"
    "--skip=sealbox::tests::test_secret_box_3"
    "--skip=sealbox::tests::test_secret_box_4"
    "--skip=sealbox::tests::test_secret_box_6"
    "--skip=sealbox::tests::test_secret_mem_box_5"
    # The procfs of the host is rejected with EXDEV
    "--skip=proc::util::tests::test_proc_overflowgid_1"
    "--skip=proc::util::tests::test_proc_overflowuid_1"
    # Toggling some sandbox flags fails with ENOSYS
    "--skip=sandbox::tests::test_sandbox_config_lock_3"

    # /usr does not exist in the build sandbox
    "--skip=landlock::ruleset::ignore_abi_v2_with_abi_v1"
    "--skip=landlock::ruleset::ruleset_compat_dummy"
    "--skip=landlock::ruleset::ruleset_created_attr"
    "--skip=lookup::tests::test_canonicalize_8"
    "--skip=lookup::tests::test_canonicalize_75"
    "--skip=lookup::tests::test_canonicalize_76"
    "--skip=lookup::tests::test_canonicalize_77"
    "--skip=lookup::tests::test_canonicalize_156"
    "--skip=lookup::tests::test_canonicalize_157"
    # Canonicalizing ".." in the build directory does not yield an owned fd
    "--skip=lookup::tests::test_canonicalize_238"
    # VFS device minor mismatch
    "--skip=unix::tests::test_unix_get_vfs_id_1"
    # assertion failed: has_vdso_symbol(c"__vdso_gettimeofday")
    "--skip=dl::tests::test_has_vdso_symbol_1"
  ];

  cargoTestFlags = [
    "--no-fail-fast"
  ];

  # TODO: Have these directories be created upstream similar to the vim files
  postInstall = ''
    mkdir -p $out/share/man/man{1,2,5,7}

    make $makeFlags install-{man,vim}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Seccomp-based application sandbox";
    homepage = "https://gitlab.exherbo.org/sydbox/sydbox";
    changelog = "https://gitlab.exherbo.org/sydbox/sydbox/-/blob/${finalAttrs.src.tag}/ChangeLog.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "syd";
    platforms = lib.platforms.linux;
  };
})
