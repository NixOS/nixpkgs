{ stdenv, lib, fetchurl, libxkbcommon, pkgconfig, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "libtsm-3";

  src = fetchurl {
    url = "http://freedesktop.org/software/kmscon/releases/${name}.tar.xz";
    sha256 = "01ygwrsxfii0pngfikgqsb4fxp8n1bbs47l7hck81h9b9bc1ah8i";
  };

  buildInputs = [ libxkbcommon pkgconfig ] ++ lib.optionals stdenv.isDarwin [
    autoconf automake
   ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    aclocal
  '';

  configureFlags = [ "--disable-debug" ];

  patches = lib.optional stdenv.isDarwin ./darwin.patch;

  meta = with lib; {
    description = "Terminal-emulator State Machine";
    homepage = "http://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = with platforms; unix;
  };
}
