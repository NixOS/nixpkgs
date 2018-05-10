{ stdenv, fetchurl, pkgconfig, cmake, extra-cmake-modules, plasma-framework, gmp }:

stdenv.mkDerivation rec {
  name = "alkimia-${version}";
  version = "7.0.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/alkimia/${version}/src/${name}.tar.xz";
    sha256 = "1fri76465058fgsyrmdrc3hj1javz4g10mfzqp5rsj7qncjr1i22";
  };

  sourceRoot = "${name}";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig cmake extra-cmake-modules plasma-framework
  ];

  propagatedBuildInputs = [ gmp ];

  meta = with stdenv.lib; {
    description = "Common classes for handling of monetary values with arbitrary precision";
    homepage = https://community.kde.org/Alkimia/libalkimia;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ exi ];
  };
}
