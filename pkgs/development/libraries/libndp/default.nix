{ lib, stdenv, fetchurl, autoreconfHook, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "libndp";
  version = "1.9";

  src = fetchurl {
    url = "http://libndp.org/files/libndp-${version}.tar.gz";
    hash = "sha256-qKshTgHcOpthUnaQU5VjfzkSmMhNd2UfDL8LEILdLdQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
  ];

  passthru.updateScript = gitUpdater {
    url = "https://github.com/jpirko/libndp.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "http://libndp.org/";
    description = "Library for Neighbor Discovery Protocol";
    mainProgram = "ndptool";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.lgpl21;
  };

}
