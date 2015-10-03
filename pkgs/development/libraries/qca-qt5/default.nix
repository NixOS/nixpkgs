{ stdenv, fetchgit, cmake, openssl, pkgconfig, qtbase }:

let
  rev = "088ff642fc2990871e3555e73c94c9287e7514a9";
  shortrev = builtins.substring 0 7 rev;
in
stdenv.mkDerivation rec {
  name = "qca-qt5-20150422-${shortrev}";
  src = fetchgit {
    url = "git://anongit.kde.org/qca.git";
    branchName = "qt5";
    inherit rev;
    sha256 = "fe1c7d5d6f38445a4032548ae3ea22c74d4327dfaf2dc88492a95facbca398f8";
  };

  buildInputs = [ openssl qtbase ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "Qt 5 Cryptographic Architecture";
    homepage = http://delta.affinix.com/qca;
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.lgpl21Plus;
  };
}
