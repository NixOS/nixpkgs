{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "libudev-zero";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "illiliti";
    repo = "libudev-zero";
    rev = version;
    sha256 = "10xsrak2y7biplqrs9628adwv9ac91qp0a3v4wcplw6ff8j6d5wc";
  };

  patches = lib.optional (stdenv.hostPlatform.isStatic)
  ./static-build-makefile.patch;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Daemonless, musl-compatible replacement for libudev";
    license = licenses.isc;
    homepage = "https://github.com/illiliti/libudev-zero";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
