{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    sha256 = "1pfy0vbs7sk7m670mclmlkpcanizdmgsm1qgwzrw28w3hxfq7gdb";
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
