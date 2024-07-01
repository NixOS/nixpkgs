{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "tlrc";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tlrc";
    rev = "v${version}";
    hash = "sha256-JQx4vuXbsLrPAbmPlwPiPXJIpRufUzQN+R+Wqj4H8n4=";
  };

  cargoHash = "sha256-5caZTdpEog8xdCn+LOfW5UdbuWZmO8iggSstxvdjwb0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage tldr.1
    installShellCompletion completions/{tldr.bash,_tldr,tldr.fish}
  '';

  meta = with lib; {
    description = "Official tldr client written in Rust";
    homepage = "https://github.com/tldr-pages/tlrc";
    changelog = "https://github.com/tldr-pages/tlrc/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "tldr";
    maintainers = with maintainers; [ acuteenvy ];
  };
}
