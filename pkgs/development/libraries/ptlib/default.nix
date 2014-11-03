{ stdenv, fetchurl, pkgconfig, bison, flex, unixODBC
, openssl, openldap, cyrus_sasl, krb5, expat, SDL, libdv, libv4l, alsaLib }:

stdenv.mkDerivation rec {
  name = "ptlib-2.10.10";

  src = fetchurl {
    url = "mirror://gnome/sources/ptlib/2.10/${name}.tar.xz";
    sha256 = "7fcaabe194cbd3bc0b370b951dffd19cfe7ea0298bfff6aecee948e97f3207e4";
  };

  buildInputs = [ pkgconfig bison flex unixODBC openssl openldap 
                  cyrus_sasl krb5 expat SDL libdv libv4l alsaLib ];

  enableParallelBuilding = true;

  patches = [ ./bison.patch ];
      
  meta = with stdenv.lib; {
    description = "Portable Tools from OPAL VoIP";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/sources/ptlib/";
    };
  };
}

