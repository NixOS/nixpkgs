{ stdenv, fetchurl }:

let version = "4.02"; in
stdenv.mkDerivation rec {
  name = "man-pages-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "1lqdzw6n3rqhd097lk5w16jcjhwfqs5zvi42hsbk3p92smswpaj8";
  };

  makeFlags = "MANDIR=$(out)/share/man";

  meta = with stdenv.lib; {
    inherit version;
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
    maintainers = with maintainers; [ nckx ];
  };
}
