{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-about";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "03f53rnn4rkd1xc2q9abnw37aq4sgvpbwhmcnckqyzc87lj6ici0";
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
    homepage = https://github.com/lxqt/lxqt-about;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
