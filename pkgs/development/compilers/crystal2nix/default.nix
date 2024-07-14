{ lib, fetchFromGitHub, crystal, makeWrapper, nix-prefetch-git }:

crystal.buildCrystalPackage rec {
  pname = "crystal2nix";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "peterhoeg";
    repo = "crystal2nix";
    rev = "v${version}";
    hash = "sha256-gb2vgKWVXwYWfUUcFvOLFF0qB4CTBekEllpyKduU1Mo=";
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

  doInstallCheck = true;

  meta = with lib; {
    description = "Utility to convert Crystal's shard.lock files to a Nix file";
    mainProgram = "crystal2nix";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru peterhoeg ];
  };
}
