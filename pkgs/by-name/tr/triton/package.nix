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
  version = "7.17.0";

  src = fetchFromGitHub {
    owner = "TritonDataCenter";
    repo = "node-triton";
    rev = version;
    hash = "sha256-udS5CnaaeaY+owOrbC3R2jrNBpuTBKOkHrIS2AlHWAE=";
  };

  npmDepsHash = "sha256-w33awTkj+YxBoPlmP0JBlZlrMmaWhMC03/5a+LB0RZ8=";

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

<<<<<<< HEAD
  meta = {
    description = "TritonDataCenter Client CLI and Node.js SDK";
    homepage = "https://github.com/TritonDataCenter/node-triton";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ teutat3s ];
=======
  meta = with lib; {
    description = "TritonDataCenter Client CLI and Node.js SDK";
    homepage = "https://github.com/TritonDataCenter/node-triton";
    license = licenses.mpl20;
    maintainers = with maintainers; [ teutat3s ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "triton";
  };
}
