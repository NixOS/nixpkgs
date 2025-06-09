{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
}:

let
  version = "0.4.10-unstable-2024-10-25";
  src = fetchFromGitHub {
    owner = "zinclabs";
    repo = "zincsearch";
    rev = "0652db6d39badc753f28ee1122dcbc0e5da1c35e";
    hash = "sha256-Py4fiZJ2fMwPe2afd19brR+62PGVoU67nMDMPlUFhKQ=";
  };

  webui = buildNpmPackage {
    inherit src version;
    pname = "zinc-ui";

    sourceRoot = "${src.name}/web";

    npmDepsHash = "sha256-2AjUaEOn2Tj+X4f42SvNq1kX07WxkB1sl5KtGdCjbdw=";

    env = {
      CYPRESS_INSTALL_BINARY = 0; # cypress tries to download binaries otherwise
    };

    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/zinc-ui
    '';
  };
in

buildGoModule rec {
  pname = "zincsearch";
  inherit src version;

  preBuild = ''
    cp -r ${webui}/share/zinc-ui web/dist
  '';

  vendorHash = "sha256-JB6+sfMB7PgpPg1lmN9/0JFRLi1c7VBUMD/d4XmLIPw=";
  subPackages = [ "cmd/zincsearch" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zinclabs/zincsearch/pkg/meta.Version=${version}"
  ];

  meta = with lib; {
    description = "Lightweight alternative to elasticsearch that requires minimal resources, written in Go";
    mainProgram = "zincsearch";
    homepage = "https://zincsearch-docs.zinc.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
