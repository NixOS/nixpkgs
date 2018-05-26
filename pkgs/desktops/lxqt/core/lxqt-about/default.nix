{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-about";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "13knjxbnq0mh9jgkllarf6rjxkvj2c93l0srnlrqp3939gcpwxh3";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "Dialogue window providing information about LXQt and the system it's running on";
    homepage = https://github.com/lxde/lxqt-about;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
