{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    sha256 = "1zll1d4apqh762iplzcm90v3yp3b36whc3vqx1vlmjgdrfss9jhn";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    install -vDt $out/json json/licenses.json
  '';

  meta = {
    description = "Various data formats for the SPDX License List";
    homepage = "https://github.com/spdx/license-list-data";
    license = lib.licenses.cc0;
  };
}
