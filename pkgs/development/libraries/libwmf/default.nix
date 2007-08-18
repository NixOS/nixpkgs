args:
args.stdenv.mkDerivation {
  name = "libwmf-0.2.8.4";

  src = args.
	fetchurl {
		url = http://dfn.dl.sourceforge.net/sourceforge/wvware/libwmf-0.2.8.4.tar.gz;
		sha256 = "1y3wba4q8pl7kr51212jwrsz1x6nslsx1gsjml1x0i8549lmqd2v";
	};

  buildInputs =(with args; [zlib imagemagick libpng
	pkgconfig glib freetype libjpeg libxml2]);

  meta = {
    description = "
	WMF library from wvWare.
";
  };
}
