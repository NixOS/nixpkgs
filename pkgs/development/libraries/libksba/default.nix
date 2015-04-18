{ stdenv, fetchurl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libksba-1.3.2";

  src = fetchurl {
    url = "mirror://gnupg/libksba/${name}.tar.bz2";
    sha256 = "01l4hvcknk9nb4bvyb6aqaid19jg0wv3ik54j1b89hnzamwm75gb";
  };

  propagatedBuildInputs = [ libgpgerror ];

  meta = with stdenv.lib; {
    homepage = http://www.gnupg.org;
    description = "CMS and X.509 access library under development";
    platforms = platforms.all;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ wkennington ];
  };
}
