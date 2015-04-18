{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kyotocabinet-1.2.76";

  src = fetchurl {
    url = "http://fallabs.com/kyotocabinet/pkg/${name}.tar.gz";
    sha256 = "0g6js20x7vnpq4p8ghbw3mh9wpqksya9vwhzdx6dnlf354zjsal1";
  };

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://fallabs.com/kyotocabinet;
    description = "a library of routines for managing a database";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
