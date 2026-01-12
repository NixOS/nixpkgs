{
  lib,
  stdenv,
  dockapps-sources,
  libx11,
  libxext,
  libXpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmCalClock";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/wmCalClock";

  buildInputs = [
    libx11
    libXpm
    libxext
  ];

  preBuild = ''
    makeFlagsArray+=(
      CC="cc"
      INCDIR="-I${libx11.dev}/include -I${libxext.dev}/include -I${libXpm.dev}/include"
      LIBDIR="-I${libx11}/lib -I${libxext}/lib -I${libXpm}/lib"
    )
  '';

  preInstall = ''
    install -d ${placeholder "out"}/bin
    install -d ${placeholder "out"}/man/man1
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = {
    description = "Calendar clock with antialiased text";
    homepage = "https://www.dockapps.net/wmcalclock";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
