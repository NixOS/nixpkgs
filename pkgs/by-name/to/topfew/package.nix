{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "topfew";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "timbray";
    repo = "topfew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P3K3IhgYkrxmEG2l7EQDVWQ+P7fOjUMUFrlAnY+8NmI=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
  ];

  postInstall = ''
    installManPage doc/tf.1
  '';

  meta = {
    description = "Finds the fields (or combinations of fields) which appear most often in a stream of records";
    homepage = "https://github.com/timbray/topfew";
    maintainers = with lib.maintainers; [ liberodark ];
    license = lib.licenses.gpl3Only;
    mainProgram = "tf";
  };
})
