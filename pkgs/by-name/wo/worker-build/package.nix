{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
<<<<<<< HEAD
  version = "0.7.2";
=======
  version = "0.6.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qhqMGvjVFgTmYXXrsMF5pJJebARXPqD7q/KmUtG0zqQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-YJHcziwrdK0mlmGS46IYIwVfy/DCsKgCB3/aq14brt4=";
=======
    hash = "sha256-c0PXLuWEY+keYRAjQkgd84Hn7IDh17SePKDF9J4ZQ5M=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-axK9/EVNKBb4xoYMOJ+0Y5nQvtkYyFDE6RsiL2MqxTM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
