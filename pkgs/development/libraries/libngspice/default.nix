<<<<<<< HEAD
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
=======
{lib, stdenv, fetchurl, bison, flex, fftw}:

# Note that this does not provide the ngspice command-line utility. For that see
# the ngspice derivation.
stdenv.mkDerivation rec {
  pname = "libngspice";
  version = "37";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    sha256 = "1gpcic6b6xk3g4956jcsqljf33kj5g43cahmydq6m8rn39sadvlv";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ fftw ];

  configureFlags = [ "--with-ngshared" "--enable-xspice" "--enable-cider" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "The Next Generation Spice (Electronic Circuit Simulator)";
    homepage = "http://ngspice.sourceforge.net";
    license = with licenses; [ bsd3 gpl2Plus lgpl2Plus ]; # See https://sourceforge.net/p/ngspice/ngspice/ci/master/tree/COPYING
<<<<<<< HEAD
    maintainers = with maintainers; [ bgamari rongcuid ];
=======
    maintainers = with maintainers; [ bgamari ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
