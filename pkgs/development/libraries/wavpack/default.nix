{ stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "wavpack";
  version = "5.3.0";

  enableParallelBuilding = true;

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  src = fetchurl {
    url = "http://www.wavpack.com/${pname}-${version}.tar.bz2";
    sha256 = "00baiag7rlkzc6545dqdp4p5sr7xc3n97n7qdkgx58c544x0pw5n";
  };

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = "http://www.wavpack.com/";
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
