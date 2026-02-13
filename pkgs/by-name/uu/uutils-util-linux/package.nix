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
  version = "0.0.1-unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "util-linux";
    rev = "30b133e62708d438ed6f55f5e012ebc26148f4f2";
    hash = "sha256-QagAhJF9L06SfGMe0fOBBAy/pkrQQGRD232EdxbwhGw=";
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

  cargoHash = "sha256-Ay917G67gICdEG98tRRgJhwYDJ140lKmn0mZa7SNels=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ util-linux ];

  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lsmartcols -lmount"
  '';

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
