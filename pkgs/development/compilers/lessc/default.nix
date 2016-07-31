{ stdenv, fetchgit, nodejs }:

stdenv.mkDerivation rec {
  name = "lessc-${version}";
  version = "1.7.5"; # Upgrade to > 2.x breaks twitter-bootstrap

  src = fetchgit {
    url = https://github.com/less/less.js.git;
    rev = "refs/tags/v${version}";
    sha256 = "1af1xbh1pjpfsx0jp69syji6w9750nigk652yk46jrja3z1scb4s";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -r $src/bin/* $out/bin/
    cp -r $src/lib/* $out/lib/
    substituteInPlace $out/bin/lessc --replace "/usr/bin/env node" ${nodejs}/bin/node
  '';

  meta = with stdenv.lib; {
    description = "LESS to CSS compiler";
    homepage = http://lesscss.org/;
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
