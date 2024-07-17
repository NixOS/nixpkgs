{
  bctoolbox,
  cmake,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "ortp";
  version = "5.2.109";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    hash = "sha256-EgUPICdKi8c/E6uonZB4DKyOZ3Od4JM5/bR2U6cq9ew=";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=stringop-truncation";

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack. Part of the Linphone project.";
    mainProgram = "ortp_tester";
    homepage = "https://linphone.org/technical-corner/ortp";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
