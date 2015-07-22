{ stdenv, fetchurl }:

let version = "4.00"; in
stdenv.mkDerivation rec {
  name = "man-pages-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "18zb1g12s15sanffh0sykmmyx0j176pp7q1xxs0gk0imgvmn8hj4";
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
