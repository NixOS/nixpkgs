{ stdenv, fetchurl, pkgconfig, libxml2, glibmm, perl }:

stdenv.mkDerivation rec {
  name = "libxml++-${maj_ver}.${min_ver}";
  maj_ver = "2.40";
  min_ver = "1";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/${maj_ver}/${name}.tar.xz";
    sha256 = "1sb3akryklvh2v6m6dihdnbpf1lkx441v972q9hlz1sq6bfspm2a";
  };

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = [ glibmm ];

  propagatedBuildInputs = [ libxml2 ];

  meta = with stdenv.lib; {
    homepage = http://libxmlplusplus.sourceforge.net/;
    description = "C++ wrapper for the libxml2 XML parser library";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ phreedom wkennington ];
  };
}
