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
  version = "7.18.1";

  src = fetchFromGitHub {
    owner = "TritonDataCenter";
    repo = "node-triton";
    rev = version;
    hash = "sha256-ODaeSTtBrGKhV28TstYaqdv7cC6OoJfZExQ/YFqBmD0=";
  };

  npmDepsHash = "sha256-Rs9Qac9o2aJRoy0bv+LqNvmer0uvy9NyMGSj0eQbxa8=";

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
    maintainers = [ ];
    mainProgram = "triton";
  };
}
