{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = "tegola";
    rev = "v${version}";
    sha256 = "sha256-Jlpw3JaU5+DO7Z5qruEMoLRf95cPGd9Z+MeDGSgbMjc=";
  };

  frontend = buildNpmPackage {
    pname = "tegola-ui";
    inherit version;

    src = "${src}/ui";

    npmDepsHash = "sha256-rhUdWt1X5/F0uvT8gI1T9ei6Y+HK1tKj2fuTKlMAwJk=";

    installPhase = ''
      cp -r dist $out
    '';
  };
in
buildGoModule {
  pname = "tegola";
  inherit version src;

  vendorHash = null;

  subPackages = [ "cmd/tegola" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-spatial/tegola/internal/build.Version=${version}"
  ];

  preBuild = ''
    rm -rf ui/dist
    cp -r ${frontend} ui/dist
    go generate ./server
  '';

  meta = with lib; {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    mainProgram = "tegola";
    maintainers = with maintainers; teams.geospatial.members ++ [ ingenieroariel ];
    license = licenses.mit;
  };
}
