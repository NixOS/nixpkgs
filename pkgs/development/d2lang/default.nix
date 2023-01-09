{ fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "d2lang";
  # 0.1.4 is broken w/ Dagre
  version = "0.1.4-2023-01-05";
  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = "d2";
    rev = "80892f9ff9317b709d7176a6bffbbd4ca92bf9a3";
    sha256 = "nG4elO7yA58XXCs74Y1CPulYcr7OfeaEA9N7Bfa/X0Y=";
  };
  vendorHash = "sha256-t94xCNteYRpbV2GzrD4ppD8xfUV1HTJPkipEzr36CaM=";
  doCheck = false;
}
