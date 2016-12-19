{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "lzo-2.09";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0k5kpj3jnsjfxqqkblpfpx0mqcy86zs5fhjhgh2kq1hksg7ag57j";
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
