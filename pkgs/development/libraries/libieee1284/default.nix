{ stdenv, fetchFromGitHub, autoconf, automake, libtool, xmlto, docbook_xml_dtd_412, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "libieee1284";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "twaugh";
    repo = pname;
    rev = "V${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "0wfv1prmhhpyll9l4g1ij3im7hk9mm96ydw3l9fvhjp3993cdn2x";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    xmlto
    docbook_xml_dtd_412
    docbook_xsl
  ];

  configureFlags = [
    "--without-python"
  ];

  preConfigure = ''
    ./bootstrap
  '';

  meta = with stdenv.lib; {
    description = "Parallel port communication library";
    homepage = "http://cyberelk.net/tim/software/libieee1284/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
