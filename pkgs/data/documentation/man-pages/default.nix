{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.61";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "1qh1rwh0klk9s1wja6rzr5gdyvijh88i0fwqap83grbgqs661c61";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
  };
}
