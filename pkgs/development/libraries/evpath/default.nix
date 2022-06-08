{ stdenv
, lib
, fetchFromGitHub
, cmake
, perl
, pkg-config
, atl
, ffs
, dill
}:

stdenv.mkDerivation rec {
  pname = "evpath";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "GTkorvo";
    repo = "evpath";
    rev = "v${version}";
    sha256 = "vx6H7u0bezxSr+QoX1JueFgVSh7uL93jFzFLfsv9ufw=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];

  buildInputs = [
    dill
  ];

  propagatedBuildInputs = [
    atl
    ffs
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"

    # Does not handle absolute paths
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = with lib; {
    description = "Event transport middleware layer";
    homepage = "https://github.com/GTkorvo/evpath";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
