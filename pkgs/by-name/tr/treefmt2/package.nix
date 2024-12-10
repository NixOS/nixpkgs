{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "treefmt";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-I97mCxQMPq6fV0GD9gVbtQ/i/Sju9/+ZazbkbGqy9Qw=";
  };

  vendorHash = "sha256-PiH+FMSPeTFwS6cMgZX8Uy2bjZnQ+APqL5d7FMnqR9U=";

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
    maintainers = [
      lib.maintainers.brianmcgee
      lib.maintainers.zimbatm
    ];
    mainProgram = "treefmt";
  };
}
