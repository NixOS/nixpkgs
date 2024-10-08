{ stdenv, lib, fetchFromGitHub, cmake, enableStatic ? stdenv.hostPlatform.isStatic }:

stdenv.mkDerivation rec {
  pname = "double-conversion";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "v${version}";
    sha256 = "sha256-DkMoHHoHwV4p40IINEqEPzKsCa0LHrJAFw2Yftw7zHo=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (! enableStatic) "-DBUILD_SHARED_LIBS=ON";

  # Case sensitivity issue
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm BUILD
  '';

  meta = with lib; {
    description = "Binary-decimal and decimal-binary routines for IEEE doubles";
    homepage = "https://github.com/google/double-conversion";
    license = licenses.bsd3;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ abbradar ];
  };
}
