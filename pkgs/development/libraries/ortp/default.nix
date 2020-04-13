{ bctoolbox
, cmake
, fetchFromGitLab
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "ortp";
  # Using master branch for linphone-desktop caused a chain reaction that many
  # of its dependencies needed to use master branch too.
  version = "unstable-2020-03-17";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "804dfc4f90d1a4301127c7af10a74fd2935dd5d8";
    sha256 = "1yr8j8am68spyy5d9vna8zcq3qn039mi16cv9jf5n4chs9rxf7xx";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=stringop-truncation";

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = "https://linphone.org/technical-corner/ortp";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
