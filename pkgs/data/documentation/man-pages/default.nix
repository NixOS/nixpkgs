{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-${version}";
  version = "4.06";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "0vv056k9yyf05dqal9m2pq3pv9c8lnp7i5rjxvcnic6aq7vyrafb";
  };

  # keep developer docs separately (man2 and man3)
  outputs = [ "out" "docdev" ];
  makeFlags = [ "MANDIR=$(out)/share/man" ];
  postFixup = ''
    moveToOutput share/man/man2 "$docdev"
  '';

  meta = with stdenv.lib; {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
    maintainers = with maintainers; [ nckx ];
  };
}
