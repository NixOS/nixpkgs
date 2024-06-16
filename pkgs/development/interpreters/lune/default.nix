{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) Security SystemConfiguration;
in
rustPlatform.buildRustPackage rec {
  pname = "lune";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "lune";
    rev = "v${version}";
    hash = "sha256-ZVETw+GdkrR2V8RrHAWBR+avAuN0158DlJkYBquju8E=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-zOjDT8Sn/p3YaG+dWyYxSWUOo11p9/WG3EyNagZRtQQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  checkFlags = [
    # require internet access
    "--skip=tests::net_request_codes"
    "--skip=tests::net_request_compression"
    "--skip=tests::net_request_methods"
    "--skip=tests::net_request_query"
    "--skip=tests::net_request_redirect"
    "--skip=tests::net_socket_wss"
    "--skip=tests::net_socket_wss_rw"
    "--skip=tests::roblox_instance_custom_async"
    "--skip=tests::serde_json_decode"

    # uses root as the CWD
    "--skip=tests::process_spawn_cwd"
  ];

  meta = with lib; {
    description = "A standalone Luau script runtime";
    mainProgram = "lune";
    homepage = "https://github.com/lune-org/lune";
    changelog = "https://github.com/lune-org/lune/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lammermann ];
    # note: Undefined symbols for architecture x86_64
    broken = stdenv.isDarwin;
  };
}
