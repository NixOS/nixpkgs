{
  lib,
  stdenv,
  fetchurl,
  automake,
  autoconf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avr-libc";
  version = "2.2.1";

  tag_version = builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
  src = fetchurl {
    url = "https://github.com/avrdudes/avr-libc/releases/download/avr-libc-${finalAttrs.tag_version}-release/avr-libc-${finalAttrs.version}.tar.bz2";
    hash = "sha256-AGpjBsu8k4w721g6xU+T/n18jPl/nN6R+RxvsCc6tGU=";
  };

  nativeBuildInputs = [
    automake
    autoconf
  ];

  # Make sure we don't strip the libraries in lib/gcc/avr.
  stripDebugList = [ "bin" ];
  dontPatchELF = true;

  enableParallelBuilding = true;

  passthru = {
    incdir = "/avr/include";
  };

  meta = with lib; {
    description = "C runtime library for AVR microcontrollers";
    homepage = "https://github.com/avrdudes/avr-libc";
    changelog = "https://github.com/avrdudes/avr-libc/blob/avr-libc-${finalAttrs.tag_version}-release/NEWS";
    license = licenses.bsd3;
    platforms = [ "avr-none" ];
    maintainers = with maintainers; [
      mguentner
      emilytrau
    ];
  };
})
