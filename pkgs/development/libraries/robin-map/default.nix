{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "robin-map";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Tessil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0blvvbr14f0drbd6dp0cs8x4ng3ppb5i72dmhk43ylg6yjgh4fhq";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Tessil/robin-map;
    description = "C++ implementation of a fast hash map and hash set using robin hood hashing";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
