{ stdenv, fetchurl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libksba-1.3.3";

  src = fetchurl {
    url = "mirror://gnupg/libksba/${name}.tar.bz2";
    sha256 = "11kp3h9l3b8ikydkcdkwgx45r662zi30m26ra5llyhfh6kz5yzqc";
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
