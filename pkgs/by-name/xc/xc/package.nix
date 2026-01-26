{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "xc";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = "xc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q17ldwHp1Wp/u0BkUZiA1pRJaFpo/5iDW011k9qkIEA=";
  };

  vendorHash = "sha256-EbIuktQ2rExa2DawyCamTrKRC1yXXMleRB8/pcKFY5c=";

  subPackages = [ "cmd/xc" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "-version";

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
    changelog = "https://github.com/joerdav/xc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      joerdav
    ];
  };
})
