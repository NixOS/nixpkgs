{ stdenv, fetchgit, nodejs }:

stdenv.mkDerivation rec {
  name = "lessc-${version}";
  version = "1.4.2";

  src = fetchgit {
    url = https://github.com/less/less.js.git;
    rev = "refs/tags/v${version}";
    sha256 = "1v3b4f1np3mxkj0irh1pk52r26nzpf4k2ax14cbn7mxx16mqjp50";
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
