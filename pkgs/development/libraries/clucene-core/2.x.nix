{stdenv, fetchurl, cmake, boost, zlib}:

stdenv.mkDerivation rec {
  name = "clucene-core-2.3.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/clucene/${name}.tar.gz";
    sha256 = "1arffdwivig88kkx685pldr784njm0249k0rb1f1plwavlrw9zfx";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost zlib ];

  cmakeFlags = [ "-DBUILD_CONTRIBS=ON" "-DBUILD_CONTRIBS_LIB=ON" ];

  patches = # From debian
    [ ./Fix-pkgconfig-file-by-adding-clucene-shared-library.patch
      ./Fixing_ZLIB_configuration_in_shared_CMakeLists.patch
      ./Install-contribs-lib.patch
    ];

  meta = {
    description = "CLucene is a port of the very popular Java Lucene text search engine API. Core package, 2.x branch.";
    homepage = http://clucene.sourceforge.net;
  };
}
