{
  lib,
  stdenv,
  dockapps-sources,
  libx11,
  libxext,
  libXpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cputnik";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/cputnik/src";

  buildInputs = [
    libx11
    libXpm
    libxext
  ];

  preBuild = ''
    makeFlagsArray+=(
      INCS="-I${libx11.dev}/include -I${libxext.dev}/include -I${libXpm.dev}/include"
      LIBS="-L${libx11}/lib -L${libxext}/lib -L${libXpm}/lib -lX11 -lXpm -lXext"
    )
  '';

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ cputnik

    runHook postInstall
  '';

  meta = {
    description = "Calendar clock with antialiased text";
    homepage = "https://www.dockapps.net/wmcalclock";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
