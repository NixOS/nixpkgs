{ bcunit
, cmake
, fetchFromGitLab
, mbedtls
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bctoolbox";
  version = "5.1.17";

  nativeBuildInputs = [ cmake bcunit ];
  buildInputs = [ mbedtls ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-p1rpFFMCYG/c35lqQT673j/Uicxe+PLhaktQfM6uF8Y=";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=stringop-truncation" ];

  meta = with lib; {
    description = "Utilities library for Linphone";
    homepage = "https://gitlab.linphone.org/BC/public/bctoolbox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin jluttine ];
    platforms = platforms.linux;
  };
}
