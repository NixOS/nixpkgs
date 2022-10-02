{ lib, stdenv, fetchurl, pkg-config, libpng, glib /*just passthru*/ }:

stdenv.mkDerivation rec {
  pname = "pixman";
  version = "0.38.4";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/${pname}-${version}.tar.bz2";
    sha256 = "0l0m48lnmdlmnaxn2021qi5cj366d9fzfjxkqgcj9bs14pxbgaw4";
  };

  separateDebugInfo = !stdenv.hostPlatform.isStatic;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpng ];

  configureFlags = lib.optional stdenv.isAarch32 "--disable-arm-iwmmxt";

  preConfigure = ''
    # https://gitlab.freedesktop.org/pixman/pixman/-/issues/62
    export OMP_NUM_THREADS=$((NIX_BUILD_CORES > 184 ? 184 : NIX_BUILD_CORES))
  '';

  doCheck = true;

  postInstall = glib.flattenInclude;

  meta = with lib; {
    homepage = "http://pixman.org";
    description = "A low-level library for pixel manipulation";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
