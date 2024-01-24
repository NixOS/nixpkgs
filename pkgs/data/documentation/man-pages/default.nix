{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "man-pages";
  version = "6.05.01";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${pname}-${version}.tar.xz";
    sha256 = "sha256-uWq2tEpojJHRtXLlL+zlGeHP0rtMM/5wFPw/0e8/nK4=";
  };

  makeFlags = [ "prefix=$(out)" ];

  dontBuild = true;

  postInstall = ''
    # conflict with shadow-utils
    rm $out/share/man/man5/passwd.5 \
       $out/share/man/man3/getspnam.3

    # The manpath executable looks up manpages from PATH. And this package won't
    # appear in PATH unless it has a /bin folder
    mkdir -p $out/bin
  '';
  outputDocdev = "out";

  enableParallelInstalling = true;

  meta = with lib; {
    description = "Linux development manual pages";
    homepage = "https://www.kernel.org/doc/man-pages/";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    priority = 30; # if a package comes with its own man page, prefer it
  };
}
