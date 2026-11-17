{
  alcotest,
  astring,
  buildDunePackage,
  camlzip,
  fetchurl,
  lib,
  ocplib-endian,
  qcheck,
  rresult,
}:

buildDunePackage (finalAttrs: {
  pname = "ezgzip";
  version = "0.2.3";
  src = fetchurl {
    url = "https://github.com/hcarty/ezgzip/releases/download/v${finalAttrs.version}/ezgzip-v${finalAttrs.version}.tbz";
    hash = "sha256-iGju25j4Oy1T8JGoJ9ubeltOm6U4u8CAyRtKxLr2edQ=";
  };
  propagatedBuildInputs = [
    astring
    camlzip
    ocplib-endian
    rresult
  ];
  checkInputs = [
    alcotest
    qcheck
  ];
  doCheck = true;
  meta = {
    description = "Simple gzip (de)compression library";
    homepage = "https://github.com/hcarty/ezgzip";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vog ];
  };
})
