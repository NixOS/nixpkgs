{stdenv, lib, fetchgit, dmd}:

stdenv.mkDerivation {
  name = "rdmd-20141113";

  buildInputs = [ dmd ];

  src = fetchgit {
    url = git://github.com/D-Programming-Language/tools.git;
    rev = "f496c68ee4e776597bd7382aa47f05da698a69e";
    sha256 = "0vbhmz8nbh8ayml4vad0239kfg982vqfyqqrjv6wrlnjah97n5ms";
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
