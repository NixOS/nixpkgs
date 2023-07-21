{ lib, stdenv, fetchFromGitHub, cmake, bison, flex, libusb-compat-0_1, libelf
, libftdi1, readline
# documentation building is broken on darwin
, docSupport ? (!stdenv.isDarwin), texlive, texinfo, texi2html, unixtools }:

stdenv.mkDerivation rec {
  pname = "avrdude";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "avrdudes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pGjOefWnf11kG/zFGwYGet1OjAhKsULNGgh6vqvIQ7c=";
  };

  nativeBuildInputs = [ cmake bison flex ] ++ lib.optionals docSupport [
    unixtools.more
    texlive.combined.scheme-medium
    texinfo
    texi2html
  ];

  buildInputs = [ libusb-compat-0_1 libelf libftdi1 readline ];

  cmakeFlags = lib.optionals docSupport [
    "-DBUILD_DOC=ON"
  ];

  # dvips output references texlive in comments, resulting in a huge closure
  postInstall = lib.optionalString docSupport ''
    rm $out/share/doc/${pname}/*.ps
  '';

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
