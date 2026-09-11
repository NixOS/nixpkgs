{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "zeno";
  version = "2.0.26";

  src = fetchFromGitHub {
    owner = "internetarchive";
    repo = "Zeno";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DuiAQKG25qFiGCAyZF9IonOGE/IZyDbowI/ZYdoQqIg=";
  };

  vendorHash = "sha256-BBPhbJT99b/rPyrGrEKAWs3/YRGVFBMOMiC1FzbIlLI=";

  env.CGO_ENABLED = true;
  ldFlags = [
    "-s"
    "-w"
  ];

  # Attempts to access internet
  doCheck = false;

  meta = {
    description = "State-of-the-art web crawler";
    longDescription = ''
      Zeno is a web crawler designed to operate wide crawls or to simply
      archive one web page. Zeno's key concepts are: portability,
      performance, simplicity. With an emphasis on performance.
    '';
    homepage = "https://github.com/internetarchive/Zeno";
    changelog = "https://github.com/internetarchive/Zeno/releases/tag/v${finalAttrs.version}";
    mainProgram = "Zeno";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
})
