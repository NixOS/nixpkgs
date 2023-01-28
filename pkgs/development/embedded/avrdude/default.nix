{ lib, stdenv, fetchFromGitHub, cmake, bison, flex, libusb-compat-0_1, libelf, libftdi1, readline
# docSupport is a big dependency, disabled by default
, docSupport ? false, texLive ? null, texinfo ? null, texi2html ? null
}:

assert docSupport -> texLive != null && texinfo != null && texi2html != null;

stdenv.mkDerivation rec {
  pname = "avrdude";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "avrdudes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pGjOefWnf11kG/zFGwYGet1OjAhKsULNGgh6vqvIQ7c=";
  };

  nativeBuildInputs = [ cmake bison flex ];

  buildInputs = [ libusb-compat-0_1 libelf libftdi1 readline ]
    ++ lib.optionals docSupport [ texLive texinfo texi2html ];

  cmakeFlags = lib.optionals docSupport [
    "-DBUILD_DOC=ON"
  ];

  meta = with lib; {
    description = "Command-line tool for programming Atmel AVR microcontrollers";
    longDescription = ''
      AVRDUDE (AVR Downloader/UploaDEr) is an utility to
      download/upload/manipulate the ROM and EEPROM contents of AVR
      microcontrollers using the in-system programming technique (ISP).
    '';
    homepage = "https://www.nongnu.org/avrdude/";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
