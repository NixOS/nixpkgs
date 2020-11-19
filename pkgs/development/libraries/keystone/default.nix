{ stdenv
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

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ];

  meta = with stdenv.lib; {
    description = "Lightweight multi-platform, multi-architecture assembler framework";
    homepage = "https://www.keystone-engine.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.unix;
  };
}
