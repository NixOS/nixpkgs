{ lib, stdenv, fetchFromGitHub, fetchurl
, autoconf, automake, libtool, xmlto, docbook_xml_dtd_412, docbook_xsl
}:

stdenv.mkDerivation rec {
  pname = "libieee1284";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "twaugh";
    repo = pname;
    rev = "V${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "0wfv1prmhhpyll9l4g1ij3im7hk9mm96ydw3l9fvhjp3993cdn2x";
  };

  patches = [
    (fetchurl {
      name = "musl.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-libs/libieee1284/files/libieee1284-0.2.11-don-t-blindly-assume-outb_p-to-be-available.patch";
      hash = "sha256-sNu0OPBMa9GIwSu754noateF4FZC14f+8YRgYUl13KQ=";
    })
  ];

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

  prePatch = ''
    ./bootstrap
  '';

  meta = with lib; {
    description = "Parallel port communication library";
    mainProgram = "libieee1284_test";
    homepage = "http://cyberelk.net/tim/software/libieee1284/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
