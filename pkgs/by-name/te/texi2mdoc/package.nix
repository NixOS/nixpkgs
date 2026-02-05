{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texi2mdoc";
  version = "0.1.2";

  src = fetchurl {
    url = "http://mdocml.bsd.lv/texi2mdoc/snapshots/texi2mdoc-${finalAttrs.version}.tgz";
    sha256 = "1zjb61ymwfkw6z5g0aqmsn6qpw895zdxv7fv3059gj3wqa3zsibs";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "http://mdocml.bsd.lv/";
    description = "Converter from Texinfo into mdoc";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ramkromberg ];
    mainProgram = "texi2mdoc";
  };
})
