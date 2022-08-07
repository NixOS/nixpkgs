{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, libminc }:

stdenv.mkDerivation rec {
  pname = "EBTKS";
  version  = "unstable-2017-09-23";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "67e4e197d8a32d6462c9bdc7af44d64ebde4fb5c";
    sha256 = "1a1qw6i47fs1izx60l1ysabpmyx9j5sjnbdv8b47wi2xcc9i3hpq";
  };

  patches = [
    # Fixes compilation for Darwin aarch64 by using the isfinite macro instead
    # of the finite function, which has been removed from libSystem.
    (fetchpatch {
      url = "https://github.com/BIC-MNI/EBTKS/pull/7/commits/03a0ef93ae274314e31c029ebb9dcaf06d19fc1e.patch";
      sha256 = "IeNCUGn0VrAh4Z32ShjGDwWCYmwhXiP1+0VcyiGg8t8=";
    })
  ];

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
