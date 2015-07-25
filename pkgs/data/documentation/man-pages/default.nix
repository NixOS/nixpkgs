{ stdenv, fetchurl }:

let version = "4.01"; in
stdenv.mkDerivation rec {
  name = "man-pages-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "116jp2rnsdlnb3cwnbfp0g053frcmchndwyrj714swl1lgabb56i";
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
