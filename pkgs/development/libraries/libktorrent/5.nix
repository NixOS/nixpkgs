{ stdenv, fetchurl, cmake, ecm
, karchive, kcrash, ki18n, kio, solid
, boost, gmp, qca-qt5, libgcrypt
}:

stdenv.mkDerivation rec {
  name = "libktorrent-2.0.1";

  src = fetchurl {
    url = http://download.kde.org/stable/ktorrent/5.0/libktorrent-2.0.1.tar.xz;
    sha256 = "0hiz4wm8jkymp24r6f1g8svj3pw9qspbjajf512m3j8s3bhrw3f7";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ecm ];
  buildInputs = [ karchive kcrash ki18n kio solid qca-qt5 libgcrypt ];

  propagatedBuildInputs = [ gmp boost ];

  enableParallelBuilding = true;

  meta = {
    description = "A BitTorrent library used by KTorrent";
    homepage = https://www.kde.org/applications/internet/ktorrent/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
