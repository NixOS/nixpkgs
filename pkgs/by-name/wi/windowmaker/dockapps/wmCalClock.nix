{ lib
, stdenv
, dockapps-sources
, libX11
, libXext
, libXpm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmCalClock";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/wmCalClock";

  buildInputs = [
    libX11
    libXpm
    libXext
  ];

  preBuild = ''
    makeFlagsArray+=(
      CC="cc"
      INCDIR="-I${libX11.dev}/include -I${libXext.dev}/include -I${libXpm.dev}/include"
      LIBDIR="-I${libX11}/lib -I${libXext}/lib -I${libXpm}/lib"
    )
  '';

  preInstall = ''
    install -d ${placeholder "out"}/bin
    install -d ${placeholder "out"}/man/man1
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = {
    description = "A Calendar clock with antialiased text";
    homepage = "https://www.dockapps.net/wmcalclock";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
