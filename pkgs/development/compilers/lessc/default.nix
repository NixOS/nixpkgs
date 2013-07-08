{ stdenv, fetchgit, nodejs }:

stdenv.mkDerivation rec {
  name = "lessc-${version}";
  version = "1.4.0";

  src = fetchgit {
    url = https://github.com/less/less.js.git;
    rev = "refs/tags/v${version}";
    sha256 = "12nzaz7v1bnqzylh4zm1srrj7w7f45fqj4sihxyg0bknfvfwdc56";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -r $src/bin/* $out/bin/
    cp -r $src/lib/* $out/lib/
    substituteInPlace $out/bin/lessc --replace "/usr/bin/env node" ${nodejs}/bin/node
  '';

  meta = {
    description = "LESS to CSS compiler";
    homepage = http://lesscss.org/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
