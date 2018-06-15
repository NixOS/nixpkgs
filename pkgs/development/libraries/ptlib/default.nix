{ stdenv, fetchurl, fetchpatch, pkgconfig, bison, flex, unixODBC
, openssl, openldap, cyrus_sasl, kerberos, expat, SDL, libdv, libv4l, alsaLib }:

stdenv.mkDerivation rec {
  name = "ptlib-2.10.11";

  src = fetchurl {
    url = "mirror://gnome/sources/ptlib/2.10/${name}.tar.xz";
    sha256 = "1jf27mjz8vqnclhrhrpn7niz4c177kcjbd1hc7vn65ihcqfz05rs";
  };

  NIX_CFLAGS_COMPILE = "-std=gnu++98";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ bison flex unixODBC openssl openldap
                  cyrus_sasl kerberos expat SDL libdv libv4l alsaLib ];

  enableParallelBuilding = true;

  patches = [
    (fetchpatch { url = http://sources.debian.net/data/main/p/ptlib/2.10.11~dfsg-2.1/debian/patches/bison-fix;
      sha256 = "0vzv9kyn9s628z8wy2gva380gi1rmhxilwlg5pikl5a0wn8p46nw";
    })
    (fetchpatch { url = http://sources.debian.net/data/main/p/ptlib/2.10.11~dfsg-2.1/debian/patches/no-sslv3;
      sha256 = "172s1dnnrl54p9sf1nl7s475sm78rpw3p8jxi0pdx6izzl8hcdr0";
    })
    ./ptlib-2.10.11-glibc-2.26.patch
  ];

  # fix typedef clashes with unixODBC>=2.3.5
  postPatch = ''
    substituteInPlace include/ptlib/unix/ptlib/contain.h \
      --replace "typedef uintptr_t    UINT" "typedef unsigned int    UINT" \
      --replace "typedef wchar_t                 WCHAR" "typedef unsigned short          WCHAR"
  '';

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
