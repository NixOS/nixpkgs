{ lib
, fetchFromGitea
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "wgautomesh";
  version = "unstable-20240524";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "wgautomesh";
    rev = "59d315b853d4251dfdfd8229152bc151655da438";
    hash = "sha256-1xphnyuRMZEeq907nyhAW7iERYJLS1kxH0wRBsfYL40=";
  };

  cargoHash = "sha256-HZ1VImsfxRd0sFN/vKAKgwIV2eio2GiEz+6c1+dCmdk=";

  meta = with lib; {
    description = "Simple utility to help connect wireguard nodes together in a full mesh topology";
    homepage = "https://git.deuxfleurs.fr/Deuxfleurs/wgautomesh";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.lx ];
    mainProgram = "wgautomesh";
  };
}
