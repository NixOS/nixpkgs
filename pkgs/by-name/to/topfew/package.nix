{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "topfew";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "timbray";
    repo = "topfew";
    rev = "v${version}";
    hash = "sha256-P3K3IhgYkrxmEG2l7EQDVWQ+P7fOjUMUFrlAnY+8NmI=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installManPage doc/tf.1
  '';

  meta = with lib; {
    description = "Finds the fields (or combinations of fields) which appear most often in a stream of records";
    homepage = "https://github.com/timbray/topfew";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "tf";
  };
}
