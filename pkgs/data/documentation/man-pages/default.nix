{ stdenv, fetchurl }:

let version = "4.03"; in
stdenv.mkDerivation rec {
  name = "man-pages-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "177w71rwsw3lsh9pjqy625s5iwz1ahdaj7prys1bpc4bqi78q5mh";
  };

  makeFlags = [ "MANDIR=$(out)/share/man" ];

  meta = with stdenv.lib; {
    inherit version;
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
    maintainers = with maintainers; [ nckx ];
  };
}
