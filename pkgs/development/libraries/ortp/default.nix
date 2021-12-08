{ bctoolbox
, cmake
, fetchFromGitLab
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "ortp";
  version = "5.0.55";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-Lu05vYSlXoltOxMsPyCzt3T8BwbYmbtf0wBw4SYiWX0=";
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
