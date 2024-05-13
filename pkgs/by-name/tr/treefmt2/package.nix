{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "treefmt";
  version = "2.0.0-rc1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-iRjd7iYd3617XZrGD6Bi6d1SoE8dgATMbT4AMXklfgM=";
  };

  vendorHash = "sha256-xbXy5Csl2JD5/F5mtvh8J36VZqrUIfO3OBV/LE+KzWA=";

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
