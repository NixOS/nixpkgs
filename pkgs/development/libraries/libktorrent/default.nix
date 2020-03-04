{ stdenv, fetchurl, cmake, extra-cmake-modules
, karchive, kcrash, ki18n, kio, solid
, boost, gmp, qca-qt5, libgcrypt
}:

let
  mainVersion = "5.1.2";

in stdenv.mkDerivation rec {
  pname = "libktorrent";
  version = "2.1.1";

  src = fetchurl {
    url    = "mirror://kde/stable/ktorrent/${mainVersion}/${pname}-${version}.tar.xz";
    sha256 = "0051zh8bb4p9wmcfn5ql987brhsaiw9880xdck7b5dm1a05mri2w";
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
