{ lib, stdenv, fetchurl, fastjet }:

stdenv.mkDerivation rec {
  pname = "fastjet-contrib";
  version = "1.045";

  src = fetchurl {
    url = "http://fastjet.hepforge.org/contrib/downloads/fjcontrib-${version}.tar.gz";
    sha256 = "1y45jx7i30ik2pjv33y16fi5i5jpmi0zp1jh32pwywd3diaiazv6";
  };

  buildInputs = [ fastjet ];

  postPatch = ''
    for f in Makefile.in */Makefile; do
      substituteInPlace "$f" --replace "CXX=g++" ""
    done
    patchShebangs ./configure ./utils/check.sh ./utils/install-sh
  '';

  enableParallelBuilding = true;

  doCheck = true;

  postBuild = ''
    make fragile-shared
  '';

  postInstall = ''
    make fragile-shared-install
  '';

  meta = with lib; {
    description = "Third party extensions for FastJet";
    homepage = "http://fastjet.fr/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
