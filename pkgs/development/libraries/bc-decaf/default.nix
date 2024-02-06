{ cmake
, fetchFromGitLab
, lib
, python3
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bc-decaf";
  version = "unstable-2022-07-20";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    python3
  ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "decaf";
    rev = "876ddb4d465c94f97beba1be450e8538d866cc5d";
    sha256 = "sha256-QFOAgLiPbG2ZdwKoCOrVD5/sPq9IH4rtAWnnk/rZWcs=";
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
