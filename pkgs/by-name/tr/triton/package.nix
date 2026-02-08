{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
  testers,
  triton,
}:

buildNpmPackage rec {
  pname = "triton";
  version = "7.18.0";

  src = fetchFromGitHub {
    owner = "TritonDataCenter";
    repo = "node-triton";
    rev = version;
    hash = "sha256-65GfN8nqr2hDz+QiBgIM/Jp5poITPUvHQYECjZMtBM4=";
  };

  npmDepsHash = "sha256-oCtS2OG3fGit54ChiVwL2Y/S4XtBVjpGumKbZgn8f00=";

  dontBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd triton --bash <($out/bin/triton completion)
    # Strip timestamp from generated bash completion
    sed -i '/Bash completion generated.*/d' $out/share/bash-completion/completions/triton.bash
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = triton;
    };
  };

  meta = {
    description = "TritonDataCenter Client CLI and Node.js SDK";
    homepage = "https://github.com/TritonDataCenter/node-triton";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ teutat3s ];
    mainProgram = "triton";
  };
}
