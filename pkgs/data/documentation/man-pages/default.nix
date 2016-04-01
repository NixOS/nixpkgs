{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-${version}";
  version = "4.05";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "03d6aqgvhcsyciwdhl50h9bwn53iivvd7rbnh8als2ia9jwm2026";
  };

  # keep developer docs separately (man2 and man3)
  outputs = [ "out" "docdev" ];
  makeFlags = [ "MANDIR=$(out)/share/man" ];
  postFixup = ''moveToOutput share/man/man2 "$docdev" '';

  meta = with stdenv.lib; {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
    maintainers = with maintainers; [ nckx ];
  };
}
