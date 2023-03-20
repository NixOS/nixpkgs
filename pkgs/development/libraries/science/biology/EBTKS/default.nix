{ lib, stdenv, fetchFromGitHub, cmake, libminc }:

stdenv.mkDerivation rec {
  pname = "EBTKS";
  version  = "unstable-2017-09-23";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "67e4e197d8a32d6462c9bdc7af44d64ebde4fb5c";
    sha256 = "1a1qw6i47fs1izx60l1ysabpmyx9j5sjnbdv8b47wi2xcc9i3hpq";
  };

  # error: use of undeclared identifier 'finite'; did you mean 'isfinite'?
  postPatch = ''
    substituteInPlace templates/EBTKS/SimpleArray.h \
      --replace "#define FINITE(x) finite(x)" "#define FINITE(x) isfinite(x)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/${pname}";
    description = "Library for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
