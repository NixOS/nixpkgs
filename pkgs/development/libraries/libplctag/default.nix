{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "libplctag";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "libplctag";
    repo = "libplctag";
    rev = "v${version}";
    sha256 = "sha256-e7WDXaFu4ujrxqSvAq2Y2MbUR1ItlKOYm9dNSPbdaMo=";
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
