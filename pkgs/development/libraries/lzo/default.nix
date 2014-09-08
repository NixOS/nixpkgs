{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "lzo-2.08";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "0536ad3ksk1r8h2a27d0y4p27lwjarzyndw7sagvxzj6xr6kw6xc";
  };

  configureFlags = [ "--enable-shared" ];

  doCheck = true;

  meta = {
    description = "A data compresion library suitable for real-time data de-/compression";
    longDescription =
      '' LZO is a data compression library which is suitable for data
	 de-/compression in real-time.  This means it favours speed over
	 compression ratio.

	 LZO is written in ANSI C.  Both the source code and the compressed
	 data format are designed to be portable across platforms.
      '';

    homepage = http://www.oberhumer.com/opensource/lzo;
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
