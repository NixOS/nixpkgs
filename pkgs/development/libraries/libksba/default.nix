{ stdenv, fetchurl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libksba-1.3.4";

  src = fetchurl {
    url = "mirror://gnupg/libksba/${name}.tar.bz2";
    sha256 = "0kxdb02z41cwm1xbwfwj9nbc0dzjhwyq8c475mlhhmpcxcy8ihpn";
  };

  propagatedBuildInputs = [ libgpgerror ];

  meta = with stdenv.lib; {
    homepage = https://www.gnupg.org;
    description = "CMS and X.509 access library";
    platforms = platforms.all;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ wkennington ];
  };
}
