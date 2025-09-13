{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-md2man,
  installShellFiles,
}:

buildGoModule rec {
  pname = "umoci";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "umoci";
    rev = "v${version}";
    sha256 = "sha256-+sUqozuIgWoP2aTuP9fPOn0zFYx0gxHfFu71LBHvhhA=";
  };

  vendorHash = null;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  postInstall = ''
    make docs SHELL="$SHELL"
    installManPage doc/man/*.[1-9]
  '';

  meta = with lib; {
    description = "Modifies Open Container images";
    homepage = "https://umo.ci";
    license = licenses.asl20;
    maintainers = with maintainers; [ zokrezyl ];
    mainProgram = "umoci";
  };
}
