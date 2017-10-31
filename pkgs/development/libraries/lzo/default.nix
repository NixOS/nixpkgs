{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "lzo-2.10";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0wm04519pd3g8hqpjqhfr72q8qmbiwqaxcs3cndny9h86aa95y60";
  };

  configureFlags = [ "--enable-shared" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
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

    homepage = http://www.oberhumer.com/opensource/lzo;
    license = licenses.gpl2Plus;

    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };
}
