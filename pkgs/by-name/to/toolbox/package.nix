{
  lib,
  buildGoModule,
  fetchFromGitHub,
  glibc,
  go-md2man,
  installShellFiles,
}:

buildGoModule rec {
  pname = "toolbox";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "toolbox";
    tag = version;
    hash = "sha256-0RSnCZQP0KzsrX5L7I8kwCxqTICbpixByQOdq3+pYPY=";
  };

  patches = [ ./glibc.patch ];

  vendorHash = "sha256-q7CN9uNxGMNggMyuDmAchQBSOMH+cxiO11qU6W5p3C8=";

  postPatch = ''
    substituteInPlace src/cmd/create.go --subst-var-by glibc ${glibc}
  '';

  modRoot = "src";

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/containers/toolbox/pkg/version.currentVersion=${version}"
  ];

  preCheck = "export PATH=$GOPATH/bin:$PATH";

  postInstall = ''
    cd ..
    for d in doc/*.md; do
      go-md2man -in $d -out ''${d%.md}
    done
    installManPage doc/*.[1-9]
    installShellCompletion --bash completion/bash/toolbox
    install profile.d/toolbox.sh -Dt $out/share/profile.d
  '';

  meta = {
    homepage = "https://containertoolbx.org";
    changelog = "https://github.com/containers/toolbox/releases/tag/${version}";
    description = "Tool for containerized command line environments on Linux";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ urandom ];
    mainProgram = "toolbox";
  };
}
