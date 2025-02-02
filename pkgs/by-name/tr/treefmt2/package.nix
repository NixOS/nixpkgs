{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "treefmt";
  version = "2.0.0-rc4";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-8l4d3ABd7XEu3ZrtBPS15N0zNHcb+A36j2EV/QZmA9U=";
  };

  vendorHash = "sha256-rjdGNfR2DpLZCzL/+3xiZ7gGDd4bPyBT5qMCO+NyWbg=";

  subPackages = [ "." ];

  CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X git.numtide.com/numtide/treefmt/build.Name=${pname}"
    "-X git.numtide.com/numtide/treefmt/build.Version=v${version}"
  ];

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brianmcgee lib.maintainers.zimbatm ];
    mainProgram = "treefmt";
  };
}
