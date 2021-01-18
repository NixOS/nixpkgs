{ mkDerivation, lib, fetchFromGitHub
, cmake, cmake-extras
, qtbase
}:

mkDerivation rec {
  pname = "libqtdbustest-unstable";
  version = "2018-06-11";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "libqtdbustest";
    rev = "24e410ea77c9fa08894365c60bf08811a3b60bc0";
    sha256 = "0py8x5qkqywfl6d14g60fn7x735qshlpc6lnk4676f8zllm8vy31";
  };

  nativeBuildInputs = [ cmake cmake-extras ];

  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "A simple library for testing Qt based DBus services and clients.";
    homepage = "https://github.com/ubports/libqtdbustest";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
