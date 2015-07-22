{stdenv, lib, fetchurl, dmd}:

stdenv.mkDerivation {
  name = "rdmd-2.067.0";

  buildInputs = [ dmd ];

  src = fetchurl {
    url = "https://github.com/D-Programming-Language/tools/archive/v2.067.0.tar.gz";
    sha256 = "2702ecda0427c675084d9b688449bc8c8392fd73e30257d79e2488640d5a9982";
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
