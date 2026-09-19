{
  lib,
  rustPlatform,
  fetchFromGitHub,
  coreutils,
  pkg-config,
  util-linux,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-util-linux";
  version = "0.0.1-unstable-2026-09-13";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "util-linux";
    rev = "b364d8263ee89db6856884dd9284342995885469";
    hash = "sha256-N+EBV5n47OVm8c6dvgTlk/Up+C0U14ncKvAozs+QFHo=";
  };

  postPatch = ''
    substituteInPlace tests/by-util/test_setsid.rs \
      --replace-fail "/usr/bin/cat" "${lib.getExe' coreutils "cat"}" \
      --replace-fail "/usr/bin/true" "${lib.getExe' coreutils "true"}" \
      --replace-fail "/usr/bin/false" "${lib.getExe' coreutils "false"}"
    substituteInPlace tests/by-util/test_setpgid.rs \
      --replace-fail "echo" "${lib.getExe' coreutils "echo"}" \
      --replace-fail '"cut"' '"${lib.getExe' coreutils "cut"}"'
  '';

  cargoHash = "sha256-RZjlS7lc8PDgDxEjemK/Xris1rJPJn7Wu0jAi8MbIOk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ util-linux ];

  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lsmartcols -lmount"
  '';

  cargoBuildFlags = [ "--workspace" ];

  checkFlags = [
    # Operation not supported
    "--skip=common::util::tests::test_compare_xattrs"
    # can't run on sandbox
    "--skip=test_last::test_display_hostname_last_column"
    "--skip=test_last::test_last"
    "--skip=test_last::test_limit_arg"
    "--skip=test_last::test_since_only_shows_entries_after_time"
    "--skip=test_last::test_timestamp_format_full"
    "--skip=test_last::test_timestamp_format_iso"
    "--skip=test_last::test_timestamp_format_no_time"
    "--skip=test_last::test_timestamp_format_short"
    "--skip=test_last::test_until_only_shows_entries_before_time"
    "--skip=test_lscpu::test_json"
    "--skip=test_lscpu::test_output"
    "--skip=test_lslocks::test_column_headers"
    "--skip=test_chcpu::linux::test_absent_cpu_is_reported_once"
    "--skip=test_chcpu::linux::test_every_absent_cpu_is_reported_once"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Rust reimplementation of the util-linux project";
    homepage = "https://github.com/uutils/util-linux";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.linux;
  };
})
