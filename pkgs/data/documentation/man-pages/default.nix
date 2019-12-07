{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "man-pages";
  version = "5.04";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${pname}-${version}.tar.xz";
    sha256 = "1bx4ws24bjq6iyfyilg7aih5f0qrhy9l97ksrwcd4yxvjh8gn13x";
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
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    priority = 30; # if a package comes with its own man page, prefer it
  };
}
