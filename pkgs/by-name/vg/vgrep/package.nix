{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go-md2man,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "vgrep";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "vrothberg";
    repo = "vgrep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OQjuNRuzFluZLssM+q+WpoRncdJMj6Sl/A+mUZA7UpI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
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

  meta = {
    description = "User-friendly pager for grep/git-grep/ripgrep";
    mainProgram = "vgrep";
    homepage = "https://github.com/vrothberg/vgrep";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
