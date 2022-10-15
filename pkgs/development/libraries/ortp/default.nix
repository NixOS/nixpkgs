{ bctoolbox
, cmake
, fetchFromGitLab
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "ortp";
  version = "5.1.55";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-FsPbpKkC1qhsZ4QBRzyV64H+lo/802qlaggDGCgbPlw=";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=stringop-truncation";

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack. Part of the Linphone project.";
    homepage = "https://linphone.org/technical-corner/ortp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
