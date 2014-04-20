{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.64";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "1p9zk130c852gqci6dyw57yaqx4v871n8n82kkccdpj7y63xr4bl";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
  };
}
