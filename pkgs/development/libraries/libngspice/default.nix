{ lib
, stdenv
, fetchurl
, flex
, bison
, fftw
, withNgshared ? true
, libXaw
, libXext
}:

stdenv.mkDerivation rec {
  pname = "${lib.optionalString withNgshared "lib"}ngspice";
  version = "41";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    hash = "sha256-HOIZOV0vUMM+siOhQD+DGLFo8ebRAVp9udv0OUCN6MQ=";
  };

  nativeBuildInputs = [
    flex
    bison
  ];

  buildInputs = [
    fftw
  ] ++ lib.optionals (!withNgshared) [
    libXaw
    libXext
  ];

  configureFlags = lib.optionals withNgshared [
    "--with-ngshared"
  ] ++ [
    "--enable-xspice"
    "--enable-cider"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [ bsd3 gpl2Plus lgpl2Plus ]; # See https://sourceforge.net/p/ngspice/ngspice/ci/master/tree/COPYING
    maintainers = with maintainers; [ bgamari rongcuid ];
    platforms = platforms.unix;
  };
}
