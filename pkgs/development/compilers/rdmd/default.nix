{stdenv, lib, fetchurl, dmd}:

stdenv.mkDerivation {
  name = "rdmd-2.071.0";

  buildInputs = [ dmd ];

  src = fetchurl {
    url = "https://github.com/D-Programming-Language/tools/archive/v2.071.0.tar.gz";
    sha256 = "0hf4sbpviwjg8n1sh212v42017jxhwghr5dw79rcmqjyp16487z4";
  };

  buildPhase = ''
    dmd rdmd.d
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp rdmd $out/bin/
	'';

  meta = {
    description = "Wrapper for D language compiler";
    homepage = http://dlang.org/rdmd.html;
    license = lib.licenses.boost;
    platforms = stdenv.lib.platforms.unix;
  };
}
