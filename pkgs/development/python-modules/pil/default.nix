{ fetchurl, stdenv, python, libjpeg, zlib, freetype }:

let version = "1.1.7"; in

stdenv.mkDerivation {
  name = "python-imaging-${version}";
  
  src = fetchurl {
    url = "http://effbot.org/downloads/Imaging-${version}.tar.gz";
    sha256 = "04aj80jhfbmxqzvmq40zfi4z3cw6vi01m3wkk6diz3lc971cfnw9";
  };

  buildInputs = [ python libjpeg zlib freetype ];

  doCheck = true;

  configurePhase = ''
    sed -i "setup.py" \
        -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = libinclude("${freetype}")|g ;
            s|^JPEG_ROOT =.*$|JPEG_ROOT = libinclude("${libjpeg}")|g ;
            s|^ZLIB_ROOT =.*$|ZLIB_ROOT = libinclude("${zlib}")|g ;'
  '';

  buildPhase   = "python setup.py build_ext -i";
  checkPhase   = "python selftest.py";
  installPhase = "python setup.py install --prefix=$out";

  meta = {
    homepage = http://www.pythonware.com/products/pil/;
    description = "The Python Imaging Library (PIL)";

    longDescription = ''
      The Python Imaging Library (PIL) adds image processing
      capabilities to your Python interpreter.  This library
      supports many file formats, and provides powerful image
      processing and graphics capabilities.
    '';

    license = "http://www.pythonware.com/products/pil/license.htm";
  };
}
