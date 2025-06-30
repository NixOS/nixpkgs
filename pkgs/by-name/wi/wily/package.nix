{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXt,
}:

stdenv.mkDerivation rec {
  version = "0.13.42";
  pname = "wily";

  src = fetchurl {
    url = "mirror://sourceforge/wily/${pname}-${version}.tar.gz";
    sha256 = "1jy4czk39sh365b0mjpj4d5wmymj98x163vmwzyx3j183jqrhm2z";
  };

  buildInputs = [
    libX11
    libXt
  ];

  patches = [ ./fix-gcc14-build.patch ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Emulation of ACME";
    homepage = "http://wily.sourceforge.net";
    license = licenses.artistic1;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "wily";
  };
}
