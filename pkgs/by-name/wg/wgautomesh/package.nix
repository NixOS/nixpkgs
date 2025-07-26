{
  lib,
  fetchFromGitea,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "wgautomesh";
  version = "unstable-20240524";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "wgautomesh";
    rev = "59d315b853d4251dfdfd8229152bc151655da438";
    hash = "sha256-1xphnyuRMZEeq907nyhAW7iERYJLS1kxH0wRBsfYL40=";
  };

  cargoHash = "sha256-Lshj8L880gGLi5xY1H/7twrL3YHolqloOfXeckGw/VE=";

  meta = with lib; {
    description = "Simple utility to help connect wireguard nodes together in a full mesh topology";
    homepage = "https://git.deuxfleurs.fr/Deuxfleurs/wgautomesh";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.lx ];
    mainProgram = "wgautomesh";
  };
}
