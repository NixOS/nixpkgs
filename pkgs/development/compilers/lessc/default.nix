{ stdenv, fetchgit, nodejs }:

stdenv.mkDerivation rec {
  name = "lessc-${version}";
  version = "1.7.5"; # Upgrade to > 2.x breaks twitter-bootstrap

  src = fetchgit {
    url = https://github.com/less/less.js.git;
    rev = "refs/tags/v${version}";
    sha256 = "0r8bcad247v5fyh543a7dppmfbf49ai4my3vcizk42fsbnjs8q2x";
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
