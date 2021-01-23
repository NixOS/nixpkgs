{ lib, stdenv, fetchurl, cmake, pkg-config, libusb1, libconfuse
, cppSupport ? true, boost ? null
, pythonSupport ? true, python3 ? null, swig ? null
, docSupport ? true, doxygen ? null
}:

assert cppSupport -> boost != null;
assert pythonSupport -> python3 != null && swig != null;
assert docSupport -> doxygen != null;

stdenv.mkDerivation rec {
  name = "libftdi1-1.4";

  src = fetchurl {
    url = "https://www.intra2net.com/en/developer/libftdi/download/${name}.tar.bz2";
    sha256 = "0x0vncf6i92slgrn0h7ghkskqbglbs534220qa84d0qg114zndpc";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = with lib; [ libconfuse ]
    ++ optionals cppSupport [ boost ]
    ++ optionals pythonSupport [ python3 swig ]
    ++ optionals docSupport [ doxygen ];

  preBuild = lib.optionalString docSupport ''
    make doc_i
  '';

  propagatedBuildInputs = [ libusb1 ];

  postInstall = ''
    mkdir -p "$out/etc/udev/rules.d/"
    cp ../packages/99-libftdi.rules "$out/etc/udev/rules.d/"
    cp -r doc/man "$out/share/"
  '' + lib.optionalString docSupport ''
    mkdir -p "$out/share/libftdi/doc/"
    cp -r doc/html "$out/share/libftdi/doc/"
  '';

  meta = with lib; {
    description = "A library to talk to FTDI chips using libusb";
    homepage = "https://www.intra2net.com/en/developer/libftdi/";
    license = with licenses; [ lgpl2 gpl2 ];
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
