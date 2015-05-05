{ stdenv, fetchurl }:

let version = "3.83"; in
stdenv.mkDerivation rec {
  name = "man-pages-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "1wksxxfvn8avfl01qk0i61zzgkkay29lpmbfal26a542yahydz3j";
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
