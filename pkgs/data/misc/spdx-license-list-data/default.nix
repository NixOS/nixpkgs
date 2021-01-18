{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.11";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    sha256 = "1iwyqhh6lh51a47mhfy98zvjan8yjsvlym8qz0isx2i1zzxlj47a";
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
