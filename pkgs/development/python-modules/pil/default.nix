args:
args.stdenv.mkDerivation {
  name = "python-imaging-1.1.6";

  src = args.fetchurl {
    url = http://effbot.org/downloads/Imaging-1.1.6.tar.gz;
    sha256 = "141zidl3s9v4vfi3nsbg42iq1lc2a932gprqr1kij5hrnn53bmvx";
  };

  buildInputs =(with args; [python zlib libtiff libjpeg freetype]);
 
  configurePhase = (with args;"
		sed -e 's@FREETYPE_ROOT = None@FREETYPE_ROOT = libinclude(\"${freetype}\")@' -i setup.py
		sed -e 's@JPEG_ROOT = None@JPEG_ROOT = libinclude(\"${libjpeg}\")@' -i setup.py
		sed -e 's@TIFF_ROOT = None@TIFF_ROOT = libinclude(\"${libtiff}\")@' -i setup.py
		sed -e 's@ZLIB_ROOT = None@ZLIB_ROOT = libinclude(\"${zlib}\")@' -i setup.py
	");

  buildPhase = "true";
	
  installPhase = "yes Y | python setup.py install --prefix=\${out}";

  meta = {
    description = "
	Python Imaging library.
";
  };
}
