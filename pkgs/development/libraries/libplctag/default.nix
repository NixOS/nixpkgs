{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "libplctag";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "libplctag";
    repo = "libplctag";
    rev = "v${version}";
    sha256 = "sha256-V0YTW7+YbyW6Fh9b1IntIxCXabPUJj7QoDvYYyc/Y6k=";
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
