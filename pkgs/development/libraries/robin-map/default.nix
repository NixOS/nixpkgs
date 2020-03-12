{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "robin-map";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "Tessil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y532zg0aaqz3fpv785n2drwpnryaclr53drpqimnbf3cs0jw997";
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
