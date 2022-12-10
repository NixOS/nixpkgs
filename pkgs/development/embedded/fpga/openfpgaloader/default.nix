{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libftdi1
, libusb1
, udev
, hidapi
, zlib
}:

stdenv.mkDerivation rec {
  pname = "openfpgaloader";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
    rev = "v${version}";
    sha256 = "sha256-CnJBmbvJ4FfKqdyoD8K94Eeoqly2Q6UV5wQ6EWv2isI=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libftdi1
    libusb1
    udev
    hidapi
    zlib
  ];

  meta = with lib; {
    description = "Universal utility for programming FPGAs";
    homepage = "https://github.com/trabucayre/openFPGALoader";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ danderson ];
  };
}
