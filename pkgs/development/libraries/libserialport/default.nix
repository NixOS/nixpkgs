{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  udev,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "libserialport";
  version = "0.1.1";

  src = fetchurl {
    url = "https://sigrok.org/download/source/libserialport/${pname}-${version}.tar.gz";
    sha256 = "17ajlwgvyyrap8z7f16zcs59pksvncwbmd3mzf98wj7zqgczjaja";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    lib.optional stdenv.isLinux udev
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.IOKit;

  meta = with lib; {
    description = "Cross-platform shared library for serial port access";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
