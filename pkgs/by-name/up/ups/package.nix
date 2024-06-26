{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "ups";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "rameshvarun";
    repo = "ups";
    rev = "v${version}";
    sha256 = "sha256-7AuZ1gyp8tAWHM0Ry54tKucPJ3enaGDtvrM1J8uBIT8=";
  };

  vendorHash = "sha256-c6aE6iD6yCnnuSEDhhr3v1ArcfLmSP8QhS7Cz7rtVHs=";

  meta = with lib; {
    description = "Command line tool for creating and applying UPS patch files";
    homepage = "https://github.com/rameshvarun/ups";
    license = licenses.mit;
    maintainers = with maintainers; [ ruby0b ];
  };
}
