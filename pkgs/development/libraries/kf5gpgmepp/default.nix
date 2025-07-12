{
  mkDerivation,
  lib,
  fetchgit,
  cmake,
  extra-cmake-modules,
  qtbase,
  boost,
  gpgme,
}:

mkDerivation {
  pname = "kf5gpgmepp";
  version = "16.08.3";

  src = fetchgit {
    url = "https://anongit.kde.org/gpgmepp.git";
    rev = "9826f6674e496ce575f606d17c318566381b3b15";
    sha256 = "02ck2l3s8s7xh44blqaqnc5k49ccicdnzvhiwa67a3zgicz5i0vh";
  };

  buildInputs = [
    qtbase
    boost
  ];
  propagatedBuildInputs = [ gpgme ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    license = [ licenses.lgpl2 ];
    platforms = platforms.linux;
  };

}
