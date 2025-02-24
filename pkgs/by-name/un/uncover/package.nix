{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "uncover";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "uncover";
    tag = "v${version}";
    hash = "sha256-q8ecgTY2uDo4O+/CqK9aYnYb4oArDIvga9C/tG9IooE=";
  };

  vendorHash = "sha256-Pm3CFHdp0VHZ5tRrjnpXXaIwQFu7EXyVgo/K9OOqHBI=";

  subPackages = [ "cmd/uncover" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-version" ];

  meta = with lib; {
    description = "API wrapper to search for exposed hosts";
    longDescription = ''
      uncover is a go wrapper using APIs of well known search engines to quickly
      discover exposed hosts on the internet. It is built with automation in mind,
      so you can query it and utilize the results with your current pipeline tools.
      Currently, it supports shodan,shodan-internetdb, censys, and fofa search API.
    '';
    homepage = "https://github.com/projectdiscovery/uncover";
    changelog = "https://github.com/projectdiscovery/uncover/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "uncover";
  };
}
