{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-jsonnet";
  version = "0.13.0";

  goPackagePath = "github.com/google/go-jsonnet";

  # regenerate deps.nix using following steps:
  #
  # go get -u github.com/google/go-jsonnet
  # cd $GOPATH/src/github.com/google/go-jsonnet
  # git checkout <version>
  # dep init
  # dep2nix
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "go-jsonnet";
    sha256 = "0x95sqhrw4pscxq0q8781wix0w881k9my5kn5nf6k0fg1d6qlgiy";
    fetchSubmodules = true;
  };

  meta = {
    description = "An implementation of Jsonnet in pure Go";
    maintainers = with lib.maintainers; [ nshalman ];
    license = lib.licenses.asl20;
    homepage = https://github.com/google/go-jsonnet;
    platforms = lib.platforms.unix;
  };
}
