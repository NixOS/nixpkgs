{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "xc";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-eaFHK7VsfLSgSJehv4urxq8qMPT+zzs2tRypz4q+MLc=";
  };

  vendorHash = "sha256-EbIuktQ2rExa2DawyCamTrKRC1yXXMleRB8/pcKFY5c=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  postInstallCheck = ''
    cp ${./example.md} example.md
    $out/bin/xc -file ./example.md example
    if ! [[ -f test ]] then
      echo "example.md didn't do anything" >&2
      return 1
    fi
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Markdown defined task runner";
    mainProgram = "xc";
    homepage = "https://xcfile.dev/";
    changelog = "https://github.com/joerdav/xc/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      joerdav
    ];
  };
}
