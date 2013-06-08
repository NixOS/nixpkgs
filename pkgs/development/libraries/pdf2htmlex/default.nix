{stdenv, fetchurl, cmake, poppler, fontforge, unzip, pkgconfig, python}:

stdenv.mkDerivation rec {
  version = "0.8.1";
  name = "pdf2htmlex-${version}";
  
  src = fetchurl {
      url = "https://github.com/coolwanglu/pdf2htmlEX/archive/v${version}.zip";
      sha256 = "0v8x03vq46ng9s27ryn76lcsjgpxgak6062jnx59lnyz856wvp8a";
  };

  buildInputs = [
    cmake
    unzip
    poppler
    fontforge
    pkgconfig
    python
  ];

  meta = with stdenv.lib; {
    description = "Convert PDF to HTML without losing text or format. ";
    license = licenses.gpl3;
    maintainers = [ maintainers.iElectric ];
    platforms = platforms.linux;
  };
}
