{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "1.1.5";
  name = "double-conversion-${version}";

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "v${version}";
    sha256 = "1a264wpnvxmnq5pdlnp417ld1ybrng83lnbg38bv4ahz7a29ap4z";
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
