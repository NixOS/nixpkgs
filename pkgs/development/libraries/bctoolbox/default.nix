{ bcunit
, cmake
, fetchFromGitLab
, mbedtls
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bctoolbox";
  version = "4.4.0";

  nativeBuildInputs = [ cmake bcunit ];
  buildInputs = [ mbedtls ];

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1r3ymwk10ry6mz4zd08q7l5msq7h15931l7f0clw2siqs8r81x7c";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=stringop-truncation" ];

  meta = with stdenv.lib; {
    inherit version;
    description = "Utilities library for Linphone";
    homepage = "https://gitlab.linphone.org/BC/public/bctoolbox";
    # Still using GPLv2 but as the rest of the Linphone projects have switched
    # to GPLv3, this might too, so check this when bumping the version number.
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin jluttine ];
    platforms = platforms.linux;
  };
}
