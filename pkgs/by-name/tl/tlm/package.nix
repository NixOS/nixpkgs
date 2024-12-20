{
  lib,
  fetchFromGitHub,
  buildGoModule,
  unstableGitUpdater,
  ollama,
}:

buildGoModule rec {
  pname = "tlm";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "yusufcanb";
    repo = "tlm";
    rev = "${version}";
    hash = "sha256-UKvgwn8yvjcREWhmwLIN8Vpbn8Ud/7wu+IluAXTVZRY=";
  };
  buildInputs = [ ollama ];
  vendorHash = "sha256-hd/xj/PX0p7Ol0zan420QQzXbZLoDZRI1VQmcraeOTc=";

  # Test expects a config file, so we create an empty one
  checkPhase = ''
    touch .tlm
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Local CLI Copilot, powered by CodeLLaMa. 💻🦙 ";
    homepage = "https://github.com/yusufcanb/tlm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fredeb ];
  };
}
