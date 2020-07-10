{ stdenv
, fetchFromGitHub
, autoreconfHook
, flex
, yacc
, xmlto
, docbook_xsl
, docbook_xml_dtd_44
, swig
, perl
, python3
}:

stdenv.mkDerivation rec {
  pname = "comedilib";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Linux-Comedi";
    repo = "comedilib";
    rev = "r${stdenv.lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "159sv4jdgmcaqz76vazkyxxb85ni7pg14p1qv7y94hib3kspc195";
  };

  nativeBuildInputs = [
    autoreconfHook
    flex
    yacc
    swig
    xmlto
    docbook_xml_dtd_44
    docbook_xsl
    python3
    perl
  ];

  preConfigure = ''
    patchShebangs --build doc/mkref doc/mkdr perl/Comedi.pm
  '';

  configureFlags = [
    "--with-udev-hotplug=${placeholder "out"}/lib"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  outputs = [ "out" "dev" "man" "doc" ];

  meta = with stdenv.lib; {
    description = "The Linux Control and Measurement Device Interface Library";
    homepage = "https://github.com/Linux-Comedi/comedilib";
    license = licenses.lgpl21;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.linux;
  };
}
