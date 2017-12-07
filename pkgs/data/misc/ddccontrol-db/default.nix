{ stdenv
, fetchurl
, perl
, perlPackages
, libxml2
, pciutils
, pkgconfig
, gtk2
}:

let version = "20061014"; in
let verName = "${version}"; in
stdenv.mkDerivation {
  name = "ddccontrol-db-${verName}";
  src = fetchurl {
    url = "mirror://sourceforge/ddccontrol/ddccontrol-db/${verName}/ddccontrol-db-${verName}.tar.bz2";
    sha1 = "9d06570fdbb4d25e397202a518265cc1173a5de3";
  };
  buildInputs =
    [
      perl
      perlPackages.libxml_perl
      libxml2
      pciutils
      pkgconfig
      gtk2
    ];

  meta = with stdenv.lib; {
    description = "Monitor database for DDCcontrol";
    homepage = http://ddccontrol.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ stdenv.lib.maintainers.pakhfn ];
  };
}
