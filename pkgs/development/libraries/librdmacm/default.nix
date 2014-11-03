{ stdenv, fetchurl, libibverbs }:

stdenv.mkDerivation rec {
  name = "librdmacm-1.0.19.1";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/rdmacm/${name}.tar.gz";
    sha256 = "0aq9x2aq62j9qn5yqifp4f2y7w2l35571ns260bwd2c60jf5fjlm";
  };

  buildInputs = [ libibverbs ];

  meta = with stdenv.lib; {
    homepage = https://www.openfabrics.org/;
    platforms = platforms.unix;
    license = licenses.bsd2;
    maintainers = with maintainers; [ wkennington ];
  };
}
