{stdenv, lib, fetchurl, dmd}:

stdenv.mkDerivation {
  name = "rdmd-2.071.0";

  buildInputs = [ dmd ];

  src = fetchurl {
    url = "https://github.com/dlang/tools/archive/v2.071.0.tar.gz";
    sha256 = "e41f444cb85ee2ca723abc950c1f875d9e0004d92208a883454ff2b8efd2c441";
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
