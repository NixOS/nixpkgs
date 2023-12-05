{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "lune";
  version = "0.7.11";

  src = fetchFromGitHub {
    owner = "filiptibell";
    repo = "lune";
    rev = "v${version}";
    hash = "sha256-5agoAXeO16/CihsgvUHt+pgA+/ph6PualTY6xqDQbeU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-kPBPxlsicoFDyOsuJWhvQHDC2uwYQqpd7S+kQPRd8DY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # these all require internet access
    "--skip=tests::net_request_codes"
    "--skip=tests::net_request_compression"
    "--skip=tests::net_request_methods"
    "--skip=tests::net_request_query"
    "--skip=tests::net_request_redirect"
    "--skip=tests::net_socket_wss"
    "--skip=tests::net_socket_wss_rw"
    "--skip=tests::roblox_instance_custom_async"
    "--skip=tests::serde_json_decode"

    # this tries to use the root directory as the CWD
    "--skip=tests::process_spawn_cwd"
  ];

  meta = with lib; {
    description = "A standalone Luau script runtime";
    homepage = "https://github.com/filiptibell/lune";
    changelog = "https://github.com/filiptibell/lune/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lammermann ];
  };
}
