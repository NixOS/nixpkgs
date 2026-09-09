{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tidyp";
  version = "1.04";

  src = fetchurl {
    # downloads from a legacy GitHub download page from ~11 years ago
    # project does not work with autoconf anymore and the configure script cannot be generated from the source download
    url = "https://github.com/downloads/petdance/tidyp/tidyp-${finalAttrs.version}.tar.gz";
    sha256 = "0f5ky0ih4vap9c6j312jn73vn8m2bj69pl2yd3a5nmv35k9zmc10";
  };

  hardeningDisable = [ "format" ];

  meta = {
    description = "Program that can validate your HTML, as well as modify it to be more clean and standard";
    mainProgram = "tidyp";
    homepage = "http://tidyp.com/";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
    license = lib.licenses.bsd3;
  };
})
