{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, perl
, libffi
}:

stdenv.mkDerivation rec {
  pname = "dill";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "GTkorvo";
    repo = "dill";
    rev = "v${version}";
    sha256 = "NiRVHAQzGDVs5Mc6kwDpbJQJoSs90qohFF5UR8huFRs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
  ];

  propagatedBuildInputs = [
    libffi
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"

    # Does not handle absolute paths
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = with lib; {
    description = "Instruction-level code generation, register allocation and simple optimizations for generating executable code directly into memory regions";
    homepage = "https://github.com/GTkorvo/dill";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
