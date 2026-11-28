{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ttt";
  version = "1.13.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eugenioenko";
    repo = "ttt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6m5/6XkwQjDK/aPZV9QNgWxgg+bVfgqeQh4E/7tryX8=";
  };

  vendorHash = "sha256-gQmx2AMj0FpWb8y7mj24YVEuxkvJsXoOcNKMdgNqreA=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/ttt" ];

  meta = {
    description = "IDE that lives in your terminal";
    homepage = "http://tttedit.dev";
    downloadPage = "https://github.com/eugenioenko/ttt";
    changelog = "https://github.com/eugenioenko/ttt/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ttt";
  };
})
