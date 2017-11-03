{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "double-conversion-${version}";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "v${version}";
    sha256 = "05x5rdwndgp1vdq2z1bpvng0dd8pn93kw4vhl6nsvv9vsara2q4b";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Binary-decimal and decimal-binary routines for IEEE doubles";
    homepage = https://github.com/google/double-conversion;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
