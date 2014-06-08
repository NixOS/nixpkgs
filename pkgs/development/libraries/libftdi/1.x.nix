{ stdenv, fetchurl, cmake, pkgconfig, libusb1, confuse
, cppSupport ? true, boost ? null
, pythonSupport ? true, python ? null, swig ? null
, docSupport ? true, doxygen ? null
}:

assert cppSupport -> boost != null;
assert pythonSupport -> python != null && swig != null;
assert docSupport -> doxygen != null;

stdenv.mkDerivation rec {
  name = "libftdi1-1.1";
  
  src = fetchurl {
    url = "http://www.intra2net.com/en/developer/libftdi/download/${name}.tar.bz2";
    sha256 = "088yh8pxd6q53ssqndydcw1dkq51cjqyahc03lm6iip22cdazcf0";
  };

  buildInputs = with stdenv.lib; [ cmake pkgconfig confuse ]
    ++ optionals cppSupport [ boost ]
    ++ optionals pythonSupport [ python swig ]
    ++ optionals docSupport [ doxygen ];

  propagatedBuildInputs = [ libusb1 ];

  postInstall = ''
    mkdir -p "$out/etc/udev/rules.d/"
    cp ../packages/99-libftdi.rules "$out/etc/udev/rules.d/"
    cp -r doc/man "$out/share/"
  '' + stdenv.lib.optionalString docSupport ''
    mkdir -p "$out/share/libftdi/doc/"
    cp -r doc/html "$out/share/libftdi/doc/"
  '';

  meta = with stdenv.lib; {
    description = "A library to talk to FTDI chips using libusb";
    homepage = http://www.intra2net.com/en/developer/libftdi/;
    license = with licenses; [ lgpl2 gpl2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
