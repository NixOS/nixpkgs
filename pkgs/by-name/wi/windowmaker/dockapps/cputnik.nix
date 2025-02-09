{ lib
, stdenv
, dockapps-sources
, libX11
, libXext
, libXpm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cputnik";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/cputnik/src";

  buildInputs = [
    libX11
    libXpm
    libXext
  ];

  preBuild = ''
    makeFlagsArray+=(
      INCS="-I${libX11.dev}/include -I${libXext.dev}/include -I${libXpm.dev}/include"
      LIBS="-L${libX11}/lib -L${libXext}/lib -L${libXpm}/lib -lX11 -lXpm -lXext"
    )
  '';

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ cputnik

    runHook postInstall
  '';

  meta = {
    description = "A Calendar clock with antialiased text";
    homepage = "https://www.dockapps.net/wmcalclock";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
