{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "treefmt";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-lDQbrq9AWH5Hjgy5AllbLLBUl/JkYGw68M5wob14kus=";
  };

  vendorHash = "sha256-OyOgTBwcRNd6kdnn3TFuq7xukeK0A1imK/WMer0tldk=";

  subPackages = [ "." ];

  CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X git.numtide.com/numtide/treefmt/build.Name=treefmt"
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
