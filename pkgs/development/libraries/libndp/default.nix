{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libndp";
  version = "1.8";

  src = fetchurl {
    url = "http://libndp.org/files/libndp-${version}.tar.gz";
    sha256 = "sha256-iP+2buLrUn8Ub1wC9cy8OLqX0rDVfrRr+6SIghqwwCs=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/jpirko/libndp/issues/26
      name = "CVE-2024-5564.patch";
      url = "https://github.com/jpirko/libndp/commit/05e4ba7b0d126eea4c04387dcf40596059ee24af.patch";
      hash = "sha256-O7AHjCqic7iUfMbKYLGgBAU+wdR9/MDWxBWJw+CFn/c=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
  ];

  meta = with lib; {
    homepage = "http://libndp.org/";
    description = "Library for Neighbor Discovery Protocol";
    mainProgram = "ndptool";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.lgpl21;
  };

}
