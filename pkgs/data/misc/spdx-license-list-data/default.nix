{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    sha256 = "0qf0g7a3jby8sngdjdic30xrb6ch56d6gzpphs8lkm6giir142rj";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    install -vDt $out/json json/licenses.json
  '';

  meta = {
    description = "Various data formats for the SPDX License List";
    homepage = "https://github.com/spdx/license-list-data";
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
  };
}
