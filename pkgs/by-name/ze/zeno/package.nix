{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "zeno";
  version = "2.0.28";

  src = fetchFromGitHub {
    owner = "internetarchive";
    repo = "Zeno";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/9s6ZkQdLLNVeKteVR0D5FnEXZNv9uepOPA8CJ0aVQg=";
  };

  vendorHash = "sha256-p4E1ZLj1AwBFS0ZlHaPdomuMXWxVV+IT+rRuYWnY1+A=";

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
