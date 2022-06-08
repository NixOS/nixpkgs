{ stdenv
, lib
, fetchFromGitHub
, cmake
, bison
, flex
, perl
, atl
, dill
}:

stdenv.mkDerivation rec {
  pname = "ffs";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "GTkorvo";
    repo = "ffs";
    rev = "v${version}";
    sha256 = "WTrlqzpBmIHEstWXnhKopKT2UWOkdzGF/7lpB1foPVo=";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
    perl
  ];

  buildInputs = [
    atl
    dill
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"

    # Does not handle absolute paths
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = with lib; {
    description = "Middleware library for highly efficient binary data communication";
    homepage = "https://github.com/GTkorvo/ffs";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
