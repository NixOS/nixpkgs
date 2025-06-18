{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "yanic";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "FreifunkBremen";
    repo = "yanic";
    rev = "v${version}";
    hash = "sha256-tKFveknZitkVFaLTZzT01SJZq1IPQfXQa7UJewjXjwU=";
  };

  vendorHash = "sha256-UYrQwOyWlKxDH5hHKAZCxQbO+eA6JsPuG0SbkWMF/HQ=";

  ldflags = [
    "-X github.com/FreifunkBremen/yanic/cmd.VERSION=${version}"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd yanic \
      --bash <($out/bin/yanic completion bash) \
      --fish <($out/bin/yanic completion fish) \
      --zsh <($out/bin/yanic completion zsh)
  '';

  meta = with lib; {
    description = "Tool to collect and aggregate respondd data";
    homepage = "https://github.com/FreifunkBremen/yanic";
    changelog = "https://github.com/FreifunkBremen/yanic/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ herbetom ];
    mainProgram = "yanic";
  };
}
