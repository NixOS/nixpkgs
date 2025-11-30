{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "vex-tui";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "CodeOne45";
    repo = "vex-tui";
    rev = "v${version}";
    hash = "sha256-QBSUmPl9yANxzROV9vyMkfxts/IyZgqA/5uxez2n/mw=";
  };

  vendorHash = "sha256-PvaV0tJjIVppB36Cxg4aAKX0MBjgFC5S4GTs1zHxCCU=";

  meta = with lib; {
    description = "A beautiful, fast, and feature-rich terminal-based Excel and CSV viewer built with Go. ";
    homepage = "https://github.com/CodeOne45/vex-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ Inarizxc ];
  };
}
