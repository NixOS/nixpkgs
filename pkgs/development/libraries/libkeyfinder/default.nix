{ stdenv, fetchFromGitHub, boost, fftw, qt5 }:

stdenv.mkDerivation rec {
  version = "0.11.0-20141105";
  name = "libkeyfinder-${version}";

  src = fetchFromGitHub {
    repo = "libKeyFinder";
    owner = "ibsh";
    rev = "592ef1f3d3ada489f80814d5ccfbc8de6029dc9d";
    sha256 = "0xcqpizwbn6wik3w7h9k1lvgrp3r3w6yyy55flvnwwwgvkry48as";
  };

  meta = with stdenv.lib; {
    description = "Musical key detection for digital audio (C++ library)";
    homepage = http://www.ibrahimshaath.co.uk/keyfinder/;
    license = with licenses; gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ fftw qt5 ];
  propagatedBuildInputs = [ boost ];

  patchPhase = ''
    substituteInPlace LibKeyFinder.pro --replace "/usr/local" "$out"
  '';

  configurePhase = ''
    qmake
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/include/keyfinder
    cp *.h $out/include/keyfinder
  '';
}
