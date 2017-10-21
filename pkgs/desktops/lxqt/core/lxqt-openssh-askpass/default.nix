{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtsvg, qtx11extras, kwindowsystem, liblxqt, libqtxdg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-openssh-askpass";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "030pzys86s7rpgl35kl4b3y7gmv9982j3blmg8927nq4pw61gfj9";
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
