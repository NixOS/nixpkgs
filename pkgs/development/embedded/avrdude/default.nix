{ lib, stdenv, fetchFromGitHub, cmake, bison, flex, libusb1, libelf
, libftdi1, readline, hidapi, libserialport
# Documentation building doesn't work on Darwin. It fails with:
#   Undefined subroutine &Locale::Messages::dgettext called in ... texi2html
#
# https://github.com/NixOS/nixpkgs/issues/224761
, docSupport ? (!stdenv.hostPlatform.isDarwin), texliveMedium, texinfo, texi2html, unixtools }:

stdenv.mkDerivation rec {
  pname = "avrdude";
  version = "7.3";

  src = fetchFromGitHub {
    owner = "avrdudes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JqW3AOMmAfcy+PQRcqviWlxA6GoMSEfzIFt1pRYY7Dw=";
  };

  nativeBuildInputs = [ cmake bison flex ] ++ lib.optionals docSupport [
    unixtools.more
    texliveMedium
    texinfo
    texi2html
  ];

  buildInputs = [ hidapi libusb1 libelf libftdi1 libserialport readline ];

  # Not used:
  #
  #   -DHAVE_LINUXGPIO=ON    because it's incompatible with libgpiod 2.x
  #
  cmakeFlags = [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "-DHAVE_LINUXSPI=ON" "-DHAVE_PARPORT=ON" ]
    ++ lib.optionals docSupport [ "-DBUILD_DOC=ON" ];

  # dvips output references texlive in comments, resulting in a huge closure
  postInstall = lib.optionalString docSupport ''
    rm $out/share/doc/${pname}/*.ps
  '';

  meta = with lib; {
    description = "Command-line tool for programming Atmel AVR microcontrollers";
    mainProgram = "avrdude";
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
