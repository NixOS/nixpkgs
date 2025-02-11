{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "libirc";
  version = "unstable-2022-10-15";

  src = fetchFromGitHub {
    owner = "grumpy-irc";
    repo = "libirc";
    rev = "734082ffffb6d6744070c75587159d927342edea";
    sha256 = "Qi/YKLlau0rdQ9XCMyreQdv4ctQWHFIoE3YlW6QnbSI=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DQT5_BUILD=1"
    "-DQt5Core_DIR=${qtbase.dev}/lib/cmake/Qt5Core"
    "-DQt5Network_DIR=${qtbase.dev}/lib/cmake/Qt5Network"
  ];

  preFixup = ''
    mkdir -p $out/libirc/libirc{,client}
    cp ../libirc/*.h $out/libirc/libirc
    cp ../libircclient/*.h $out/libirc/libircclient
  '';

  meta = with lib; {
    description = "C++ IRC library written in Qt with support for data serialization";
    homepage = "https://github.com/grumpy-irc/libirc";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ fee1-dead ];
    platforms = platforms.linux;
  };
}
