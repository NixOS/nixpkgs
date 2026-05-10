{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tetgen";
  version = "1.4.3";

  src = fetchurl {
    url = "${finalAttrs.meta.homepage}/files/tetgen${finalAttrs.version}.tar.gz";
    sha256 = "0d70vjqdapmy1ghlsxjlvl5z9yp310zw697bapc4zxmp0sxi29wm";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp tetgen $out/bin
  '';

  meta = {
    description = "Quality Tetrahedral Mesh Generator and 3D Delaunay Triangulator";
    mainProgram = "tetgen";
    homepage = "http://tetgen.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
