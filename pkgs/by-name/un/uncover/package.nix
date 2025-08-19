{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "uncover";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "uncover";
    tag = "v${version}";
    hash = "sha256-BRh25lvk3Zut5M6dedLuSET4514R9j0fUHmamw4rp5U=";
  };

  vendorHash = "sha256-6TvPKp/P0v/ZJRGRICp77C/8FHupyr9Hy2+zlYc2HIU=";

  subPackages = [ "cmd/uncover" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = "-version";

  meta = {
    description = "API wrapper to search for exposed hosts";
    longDescription = ''
      uncover is a go wrapper using APIs of well known search engines to quickly
      discover exposed hosts on the internet. It is built with automation in mind,
      so you can query it and utilize the results with your current pipeline tools.
      Currently, it supports shodan,shodan-internetdb, censys, and fofa search API.
    '';
    homepage = "https://github.com/projectdiscovery/uncover";
    changelog = "https://github.com/projectdiscovery/uncover/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "uncover";
  };
}
