{ bctoolbox
, cmake
, fetchFromGitLab
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "ortp";
  version = "4.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "1lc1j7wvkyp5lhcflq3h5y7n8aiwgwj84ffm81ggbsmavamgwkk7";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=stringop-truncation";

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = "https://linphone.org/technical-corner/ortp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
