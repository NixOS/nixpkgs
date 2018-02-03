{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-${version}";
  version = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "0wf9ymqxk1k5xwcl3n919p66a1aayif3x4cahj4w04y3k1wbhlih";
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
    platforms = with platforms; unix;
  };
}
