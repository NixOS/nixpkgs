{ lib, fetchFromGitHub, crystal, makeWrapper, nix-prefetch-git }:

crystal.buildCrystalPackage rec {
  pname = "crystal2nix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "peterhoeg";
    repo = "crystal2nix";
    rev = "v${version}";
    sha256 = "sha256-K1ElG8VC/D0axmSRaufH3cE50xNQisAmFucDkV+5O0s=";
  };

  format = "shards";

  shardsFile = ./shards.nix;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/crystal2nix \
      --prefix PATH : ${lib.makeBinPath [ nix-prefetch-git ]}
  '';

  # temporarily off. We need the checks to execute the wrapped binary
  doCheck = false;

  # it requires an internet connection when run
  doInstallCheck = false;

  meta = with lib; {
    description = "Utility to convert Crystal's shard.lock files to a Nix file";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru peterhoeg ];
  };
}
