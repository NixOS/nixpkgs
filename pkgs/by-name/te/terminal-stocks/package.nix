{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "terminal-stocks";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "shweshi";
    repo = "terminal-stocks";
    rev = "v${version}";
    hash = "sha256-YrdOw5le+gR8eANS57/uSGwrBfRJiLNkTR8InrEAI7o=";
  };

  npmDepsHash = "sha256-TAS7iPWXXLaDosM31WYpeXC2Gz01fucoFu7llwBHmxc=";
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Terminal based application that provides stock price information";
    homepage = "https://github.com/shweshi/terminal-stocks";
    maintainers = with maintainers; [ mislavzanic ];
    license = licenses.mit;
    mainProgram = "terminal-stocks";
  };
}
