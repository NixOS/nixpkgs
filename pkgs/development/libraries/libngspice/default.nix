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
  version = "42";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    hash = "sha256-c3/jhGqyMzolDfrfHtbr4YYK8dil/154A8dyzEJW5Qo=";
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
    description = "Next Generation Spice (Electronic Circuit Simulator)";
    mainProgram = "ngspice";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [ bsd3 gpl2Plus lgpl2Plus ]; # See https://sourceforge.net/p/ngspice/ngspice/ci/master/tree/COPYING
    maintainers = with maintainers; [ bgamari rongcuid ];
    platforms = platforms.unix;
  };
}
