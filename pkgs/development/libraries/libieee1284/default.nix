{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoconf,
  automake,
  libtool,
  xmlto,
  docbook_xml_dtd_412,
  docbook_xsl,
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
    # Fix build on Musl.
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/861ac185a6b60134292ff93d40e40b5391d0aa8e/srcpkgs/libieee1284/patches/musl.patch";
      sha256 = "03xivd6z7m51i5brlmzs60pjrlqyr4561qlnh182wa7rrm01x5y6";
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
