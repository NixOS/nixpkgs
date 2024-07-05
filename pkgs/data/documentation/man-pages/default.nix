{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "man-pages";
  version = "6.9";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${pname}-${version}.tar.xz";
    hash = "sha256-0Uyv9UzGYvNLG3C89i1OJ+TC/SYGcqNbbnSvcbP3H4g=";
  };

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  dontBuild = true;

  outputDocdev = "out";

  enableParallelInstalling = true;

  postInstall = ''
    # The manpath executable looks up manpages from PATH. And this package won't
    # appear in PATH unless it has a /bin folder. Without the change
    # 'nix-shell -p man-pages' does not pull in the search paths.
    # See 'man 5 manpath' for the lookup order.
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Linux development manual pages";
    homepage = "https://www.kernel.org/doc/man-pages/";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    priority = 30; # if a package comes with its own man page, prefer it
  };
}
