{ stdenv, fetchurl, cmake, extra-cmake-modules
, karchive, kcrash, ki18n, kio, solid
, boost, gmp, qca-qt5, libgcrypt
}:

let
    mainVersion = "5.1";

in stdenv.mkDerivation rec {
  name = "libktorrent-2.1";

  src = fetchurl {
    url    = "mirror://kde/stable/ktorrent/${mainVersion}/${name}.tar.xz";
    sha256 = "0vz2dwc4xd80q56g6r5bx5wqdl9fxcibxmw2irahqhbkxk7drvry";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ karchive kcrash ki18n kio solid qca-qt5 libgcrypt ];

  propagatedBuildInputs = [ gmp boost ];

  enableParallelBuilding = true;

  passthru = {
    inherit mainVersion;
  };

  meta = with stdenv.lib; {
    description = "A BitTorrent library used by KTorrent";
    homepage    = https://www.kde.org/applications/internet/ktorrent/;
    maintainers = with maintainers; [ eelco ];
    platforms   = platforms.linux;
  };
}
