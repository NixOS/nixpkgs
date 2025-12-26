{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${version}";
    hash = "sha256-qhqMGvjVFgTmYXXrsMF5pJJebARXPqD7q/KmUtG0zqQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-YJHcziwrdK0mlmGS46IYIwVfy/DCsKgCB3/aq14brt4=";

  buildAndTestSubdir = "worker-build";

  meta = {
    description = "Tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project";
    mainProgram = "worker-build";
    homepage = "https://github.com/cloudflare/workers-rs";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
