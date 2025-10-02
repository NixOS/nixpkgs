{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wego";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "schachmat";
    repo = "wego";
    rev = version;
    sha256 = "sha256-YGUll0Wi/oulNMXSrSFeAVe+aGpyFeyXRZTW4ngC3Zk=";
  };

  vendorHash = "sha256-aXrXw/7ZtSZXIKDMZuWPV2zAf0e0lU0QCBhua7tHGEY=";

  meta = with lib; {
    homepage = "https://github.com/schachmat/wego";
    description = "Weather app for the terminal";
    license = licenses.isc;
    mainProgram = "wego";
  };
}
