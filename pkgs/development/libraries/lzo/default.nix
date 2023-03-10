{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "lzo";
  version = "2.10";

  src = fetchurl {
    url = "https://www.oberhumer.com/opensource/lzo/download/${pname}-${version}.tar.gz";
    sha256 = "0wm04519pd3g8hqpjqhfr72q8qmbiwqaxcs3cndny9h86aa95y60";
  };

  configureFlags = lib.optional (!stdenv.hostPlatform.isStatic) "--enable-shared" ;

  enableParallelBuilding = true;

  doCheck = true; # not cross;

  strictDeps = true;

  meta = with lib; {
    description = "Real-time data (de)compression library";
    longDescription = ''
      LZO is a portable lossless data compression library written in ANSI C.
      Both the source code and the compressed data format are designed to be
      portable across platforms.
      LZO offers pretty fast compression and *extremely* fast decompression.
      While it favours speed over compression ratio, it includes slower
      compression levels achieving a quite competitive compression ratio
      while still decompressing at this very high speed.
    '';

    homepage = "http://www.oberhumer.com/opensource/lzo";
    license = licenses.gpl2Plus;

    platforms = platforms.all;
  };
}
