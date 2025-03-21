{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "yaml2json";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "bronze1man";
    repo = "yaml2json";
    rev = "v${version}";
    hash = "sha256-mIjtR1VsSeUhEgeSKDG0qT0kj+NCqVwn31m300cMDeU=";
  };

  vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/bronze1man/yaml2json";
    description = "Convert yaml to json";
    mainProgram = "yaml2json";
    license = with licenses; [ mit ];
    maintainers = [ ];
  };
}
