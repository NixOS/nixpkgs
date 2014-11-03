{ stdenv, fetchurl, writeText, lib, dmd }:

stdenv.mkDerivation {
  name = "rdmd-2.064";

  src = fetchurl {
    url = https://raw2.github.com/D-Programming-Language/tools/2.064/rdmd.d;
    sha256 = "0b1g3ng6bkanvg00r6xb4ycpbh9x8b9dw589av665azxbcraqrs1";
    name = "rdmd-src";
  };

  buildInputs = [ dmd ];

  builder = writeText "drmd-builder.sh" ''
      source $stdenv/setup
      cp $src rdmd.d
      dmd rdmd.d
      mkdir -p $out/bin
      cp rdmd $out/bin/
  '';

  meta = {
    description = "Wrapper for D language compiler";
    homepage = http://dlang.org/rdmd.html;
    license = lib.licenses.boost;
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
    platforms = stdenv.lib.platforms.unix;
  };
}
