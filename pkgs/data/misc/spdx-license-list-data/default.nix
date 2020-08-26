{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.10";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    sha256 = "1zza0jrs82112dcjqgkyck2b7hv4kg9s10pmlripi6c1rs37av14";
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
