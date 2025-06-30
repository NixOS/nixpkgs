{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "go-spatial";
    repo = "tegola";
    tag = "v${version}";
    hash = "sha256-aJCxxeewOm7DOHmehnsDKoQPwPnUMsjVit41ccY6tLg=";
  };

  frontend = buildNpmPackage {
    pname = "tegola-ui";
    inherit version;

    src = "${src}/ui";

    npmDepsHash = "sha256-DHJ+l3ceLieGG97kH1ri+7yZAv7R2lVYRdBhjXCy/iM=";

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

  meta = {
    homepage = "https://www.tegola.io/";
    description = "Mapbox Vector Tile server";
    mainProgram = "tegola";
    maintainers = with lib.maintainers; [ ingenieroariel ];
    teams = [ lib.teams.geospatial ];
    license = lib.licenses.mit;
  };
}
