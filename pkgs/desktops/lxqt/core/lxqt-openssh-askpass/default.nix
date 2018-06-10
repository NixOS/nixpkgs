{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtsvg, qtx11extras, kwindowsystem, liblxqt, libqtxdg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-openssh-askpass";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "16xcw4yll6i9vij16kdb10s4aq2s57x4yjlwv6d8r75y5gq9iiw6";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "GUI to query passwords on behalf of SSH agents";
    homepage = https://github.com/lxde/lxqt-openssh-askpass;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
