{ cmake
, fetchFromGitLab
, lib
, python3
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bc-decaf";
  version = "linphone-4.4.1";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    python3
  ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "decaf";
    rev = "6e78a9beb24d1e3d7050dd52a65e4f88b101a1fc";
    sha256 = "sha256-D2SzkinloL0Ya9p25YUsc+7lKvoTMUsdkKrkv/5AEeY=";
  };

  # Do not build static libraries and do not enable -Werror
  cmakeFlags = [ "-DENABLE_STATIC=NO" "-DENABLE_STRICT=NO" ];

  meta = with lib; {
    description = "Elliptic curve library supporting Ed448-Goldilocks and Curve25519. Belledonne Communications' fork for Linphone.";
    homepage = "https://gitlab.linphone.org/BC/public/bctoolbox";
    license = licenses.mit;
    maintainers = with maintainers; [ thibaultlemaire ];
    platforms = platforms.linux;
  };
}
