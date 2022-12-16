{ bcunit
, cmake
, bc-decaf
, fetchFromGitLab
, mbedtls_2
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bctoolbox";
  version = "5.1.17";

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    # Made by BC
    bcunit

    # Vendored by BC
    bc-decaf

    mbedtls_2
  ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-p1rpFFMCYG/c35lqQT673j/Uicxe+PLhaktQfM6uF8Y=";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" "-DENABLE_STRICT=NO" ];

  strictDeps = true;

  meta = with lib; {
    description = "Utilities library for Linphone";
    homepage = "https://gitlab.linphone.org/BC/public/bctoolbox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin jluttine ];
    platforms = platforms.linux;
  };
}
