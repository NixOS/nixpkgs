{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "keystone";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "keystone-engine";
    repo = pname;
    rev = version;
    sha256 = "020d1l1aqb82g36l8lyfn2j8c660mm6sh1nl4haiykwgdl9xnxfa";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ];

  meta = with lib; {
    description = "Lightweight multi-platform, multi-architecture assembler framework";
    homepage = "https://www.keystone-engine.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ luc65r ];
    mainProgram = "kstool";
    platforms = platforms.unix;
  };
}
