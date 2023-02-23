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
  version = "5.2.23";

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
    hash = "sha256-Qiix68NAKBOXIkS+74+QtLv95UftuH8xOmrjLn6W+qc=";
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
