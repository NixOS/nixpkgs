{ stdenv, fetchurl
, libjpeg ? null, libpng ? null, libmng ? null, lcms1 ? null, libtiff ? null, openexr ? null, mesa ? null, xlibs ? null }:
stdenv.mkDerivation rec {

  name ="libdevil-${version}";
  version = "1.7.8";

  src = fetchurl {
    url = "mirror://sourceforge/openil/DevIL-${version}.tar.gz";
    sha256 = "1zd850nn7nvkkhasrv7kn17kzgslr5ry933v6db62s4lr0zzlbv8";
  };

  buildInputs = [ libjpeg libpng libmng lcms1 libtiff openexr mesa xlibs.libX11 ];
  configureFlags = [ "--enable-ILU" "--enable-ILUT" ];

  meta = with stdenv.lib; {
    homepage = http://openil.sourceforge.net/;
    description = "An image library which can can load, save, convert, manipulate,
      filter and display a wide variety of image formats.";
    license = licenses.lgpl2;
    maintainers = [ maintainers.phreedom ];
  };
}