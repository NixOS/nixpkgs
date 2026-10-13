{
  lib,
  stdenv,
  fetchurl,
  libx11,
  libxtst,
  xorgproto,
  libxi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmacro";
  version = "0.4.6";

  src = fetchurl {
    url = "http://download.sarine.nl/xmacro/xmacro-${finalAttrs.version}.tar.gz";
    sha256 = "1p9jljxyn4j6piljiyi2xv6f8jhjbzhabprp8p0qmqxaxgdipi61";
  };

  preInstall = "echo -e 'install:\n	mkdir \${out}/bin;\n	cp xmacrorec2 xmacroplay \${out}/bin;' >>Makefile; ";

  buildInputs = [
    libx11
    libxtst
    xorgproto
    libxi
  ];

  meta = {
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
