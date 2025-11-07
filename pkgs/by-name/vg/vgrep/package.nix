{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-md2man,
  installShellFiles,
}:

buildGoModule rec {
  pname = "vgrep";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "vrothberg";
    repo = "vgrep";
    rev = "v${version}";
    hash = "sha256-OQjuNRuzFluZLssM+q+WpoRncdJMj6Sl/A+mUZA7UpI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  postBuild = ''
    sed -i '/SHELL= /d' Makefile
    make docs
    installManPage docs/*.[1-9]
  '';

  meta = with lib; {
    description = "User-friendly pager for grep/git-grep/ripgrep";
    mainProgram = "vgrep";
    homepage = "https://github.com/vrothberg/vgrep";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
