{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "urlfinder";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "urlfinder";
    rev = "refs/tags/v${version}";
    hash = "sha256-hORZzeGNcRTcFsvY8pfs8f1JNpdTJjMdO/lJHR83DfY=";
  };

  vendorHash = "sha256-Wu9itQfcrwWuzRHtTKk+lF7n6eIzSfATWtI+8xLQQsI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool for passively gathering URLs without active scanning";
    homepage = "https://github.com/projectdiscovery/urlfinder";
    changelog = "https://github.com/projectdiscovery/urlfinder/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "urlfinder";
  };
}
