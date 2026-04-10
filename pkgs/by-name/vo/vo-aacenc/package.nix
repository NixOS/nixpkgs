{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vo-aacenc";
  version = "0.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/vo-aacenc-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-5Rp0d6NZ8Y33xPgtGV2rThTnQUy9SM95zBlfxEaFDzY=";
  };

  meta = {
    description = "VisualOn AAC encoder library";
    homepage = "https://sourceforge.net/projects/opencore-amr/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.baloo ];
    platforms = lib.platforms.all;
  };
})
