{ stdenv, fetchurl, libogg }:

stdenv.mkDerivation rec {
  name = "speex-1.2rc1";

  src = fetchurl {
    url = "http://downloads.us.xiph.org/releases/speex/${name}.tar.gz";
    sha256 = "19mpkhbz3s08snvndn0h1dk2j139max6b0rr86nnsjmxazf30brl";
  };

  buildInputs = [ libogg ];

  outputs = [ "dev" "out" "bin" "doc" ];

  meta = {
    homepage = http://www.speex.org/;
    description = "A audio compression codec designed for speech";
  };
}
