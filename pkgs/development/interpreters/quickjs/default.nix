{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "quickjs";
  version = "2019-07-09";

  src = fetchurl {
    url = "https://bellard.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0r6mgh0m85c11y8ah5iphzpw518br0hi36f92mgdg2iivpciq31m";
  };

  postPatch = ''
    sed -e "s/^CONFIG_M32=y/#&/" -i Makefile
  '';

  makeFlags = [ "prefix=${placeholder ''out''}" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A small and embeddable Javascript engine";
    homepage = https://bellard.org/quickjs/;
    maintainers = [ maintainers.stesie ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
