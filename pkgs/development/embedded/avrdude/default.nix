{ lib, callPackage, stdenv, fetchFromGitHub, cmake, bison, flex, libusb1, elfutils
, libftdi1, readline, hidapi, libserialport, libusb-compat-0_1
# Documentation building doesn't work on Darwin. It fails with:
#   Undefined subroutine &Locale::Messages::dgettext called in ... texi2html
#
# https://github.com/NixOS/nixpkgs/issues/224761
, docSupport ? (!stdenv.hostPlatform.isDarwin), texliveMedium, texinfo, texi2html, unixtools }:

let
  useElfutils = lib.meta.availableOn stdenv.hostPlatform elfutils;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "avrdude";
  version = "7.3";

  src = fetchFromGitHub {
    owner = "avrdudes";
    repo = "avdude";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JqW3AOMmAfcy+PQRcqviWlxA6GoMSEfzIFt1pRYY7Dw=";
  };

  nativeBuildInputs = [ cmake bison flex ] ++ lib.optionals docSupport [
    unixtools.more
    texliveMedium
    texinfo
    texi2html
  ];

  buildInputs = [
    (if useElfutils then elfutils else finalAttrs.finalPackage.passthru.libelf)
    hidapi
    libusb1
    libftdi1
    libserialport
    readline
    libusb-compat-0_1
  ];

  postPatch = lib.optionalString (!useElfutils) ''
    # vendored libelf is a static library
    sed -i "s/PREFERRED_LIBELF elf/PREFERRED_LIBELF libelf.a elf/" CMakeLists.txt
  '';

  # Not used:
  #   -DHAVE_LINUXGPIO=ON    because it's incompatible with libgpiod 2.x
  cmakeFlags = lib.optionals docSupport [ "-DBUILD_DOC=ON" ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "-DHAVE_LINUXSPI=ON" "-DHAVE_PARPORT=ON" ];

  # dvips output references texlive in comments, resulting in a huge closure
  postInstall = lib.optionalString docSupport ''
    rm $out/share/doc/avrdude/*.ps
  '';

  passthru = {
    # Vendored and mutated copy of libelf for avrdudes use.
    # Produces a static library only.
    libelf = callPackage ./libelf.nix { };
  };

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
})
