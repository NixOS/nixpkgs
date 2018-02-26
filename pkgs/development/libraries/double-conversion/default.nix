{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "double-conversion-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "v${version}";
    sha256 = "05m78wlwrg310mxh1cl3d8d0ishzfvzh84x64xmvng252m0vc8yz";
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
