{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "libplctag";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "libplctag";
    repo = "libplctag";
    rev = "v${version}";
    sha256 = "sha256-v6Gp9C5r5WMFR+LAZPlUKQ4EiBDmbscPEKKDv7gaTEo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/libplctag/libplctag";
    description = "Library that uses EtherNet/IP or Modbus TCP to read and write tags in PLCs";
    license = with licenses; [ lgpl2Plus mpl20 ];
    maintainers = with maintainers; [ petterstorvik ];
    platforms = platforms.all;
  };
}
