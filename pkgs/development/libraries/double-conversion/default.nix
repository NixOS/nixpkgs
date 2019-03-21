{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "double-conversion-${version}";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "v${version}";
    sha256 = "082w15xq8f4c422a71phvcahgc8vmqrig97av9g9628q5n2ybbgg";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  # Case sensitivity issue
  preConfigure = lib.optionalString stdenv.isDarwin ''
    rm BUILD
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Binary-decimal and decimal-binary routines for IEEE doubles";
    homepage = https://github.com/google/double-conversion;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
