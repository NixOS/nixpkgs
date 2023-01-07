{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "robin-map";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Tessil";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-axVMJHTnGW2c4kGcYhEEAvKbVKYA2oxiYfwjiz7xh6Q=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/Tessil/robin-map";
    description = "C++ implementation of a fast hash map and hash set using robin hood hashing";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
  };
}
