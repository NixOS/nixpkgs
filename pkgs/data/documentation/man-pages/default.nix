{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-${version}";
  version = "4.11";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "097m0gsbaz0gf9ir4lmph3h5jj6wmydk1rglfz82dysybx4q1pmd";
  };

  makeFlags = [ "MANDIR=$(out)/share/man" ];
  postInstall = ''
    # conflict with shadow-utils
    rm $out/share/man/man5/passwd.5 \
       $out/share/man/man3/getspnam.3
  '';
  outputDocdev = "out";

  meta = with stdenv.lib; {
    description = "Linux development manual pages";
    homepage = https://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; unix;
  };
}
