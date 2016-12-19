{ stdenv, fetchurl, alsaLib, cmake, docbook_xsl, docbook_xml_dtd_45, doxygen
, fluidsynth, pkgconfig, qt5
}:

stdenv.mkDerivation rec {
  name = "drumstick-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/drumstick/${version}/${name}.tar.bz2";
    sha256 = "0l47gy9yywrc860db5g3wdqg8yc8qdb2lqq6wvw1dfim5j0vbail";
  };

  outputs = [ "out" "dev" "man" ];

  enableParallelBuilding = true;

  # Prevent the manpage builds from attempting to access the Internet.
  prePatch = ''
    substituteInPlace cmake_admin/CreateManpages.cmake --replace \
      http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl \
      ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl

    for xml in doc/*.xml.in; do
      substituteInPlace "$xml" --replace \
        http://www.docbook.org/xml/4.5/docbookx.dtd \
        ${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd
    done
  '';

  buildInputs = [
    alsaLib cmake doxygen fluidsynth pkgconfig qt5.qtbase qt5.qtsvg
  ];

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ solson ];
    description = "MIDI libraries for Qt5/C++";
    homepage = http://drumstick.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
