{ fetchurl, stdenv, pkgconfig, autoreconfHook, gettext, glib, buildPackages }:


stdenv.mkDerivation rec {
  pname = "gts";
  version = "0.7.6";

  outputs = [ "bin" "dev" "out" ];

  src = fetchurl {
    url = "mirror://sourceforge/gts/${pname}-${version}.tar.gz";
    sha256 = "07mqx09jxh8cv9753y2d2jsv7wp8vjmrd7zcfpbrddz3wc9kx705";
  };

  nativeBuildInputs = [
    pkgconfig
    autoreconfHook
    glib  # required to satisfy AM_PATH_GLIB_2_0
  ];
  buildInputs = [ gettext ];
  propagatedBuildInputs = [ glib ];

  doCheck = false; # fails with "permission denied"

  preBuild = stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    pushd src
    make CC=${buildPackages.stdenv.cc}/bin/cc predicates_init
    mv predicates_init predicates_init_build
    make clean
    popd

    substituteInPlace src/Makefile --replace "./predicates_init" "./predicates_init_build"
  '';

  meta = {
    homepage = "http://gts.sourceforge.net/";
    license = stdenv.lib.licenses.lgpl2Plus;
    description = "GNU Triangulated Surface Library";

    longDescription = ''
      Library intended to provide a set of useful functions to deal with
      3D surfaces meshed with interconnected triangles.
    '';

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
