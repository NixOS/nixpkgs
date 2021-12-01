{ lib, stdenv, fetchurl, fastjet }:

stdenv.mkDerivation rec {
  pname = "fastjet-contrib";
  version = "1.046";

  src = fetchurl {
    url = "http://fastjet.hepforge.org/contrib/downloads/fjcontrib-${version}.tar.gz";
    sha256 = "sha256-cgavrH/rIHXZn7sDa7NRPTKy2sOvMDQQJjmGNUeT7s8=";
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
