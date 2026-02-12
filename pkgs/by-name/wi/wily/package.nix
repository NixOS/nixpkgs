{
  lib,
  stdenv,
  fetchurl,
  libx11,
  libxt,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.13.42";
  pname = "wily";

  src = fetchurl {
    url = "mirror://sourceforge/wily/wily-${finalAttrs.version}.tar.gz";
    sha256 = "1jy4czk39sh365b0mjpj4d5wmymj98x163vmwzyx3j183jqrhm2z";
  };

  buildInputs = [
    libx11
    libxt
  ];

  patches = [ ./fix-gcc14-build.patch ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Emulation of ACME";
    homepage = "http://wily.sourceforge.net";
    license = lib.licenses.artistic1;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "wily";
  };
})
