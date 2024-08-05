{
  lib,
  libX11,
  libXext,
  libXpm,
  stdenv,
  windowmaker,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cputnik";
  inherit (finalAttrs.src) version;

  src = windowmaker.dockapps.dockapps-sources;

  sourceRoot = "${finalAttrs.src.name}/cputnik/src";

  buildInputs = [
    libX11
    libXext
    libXpm
  ];

  hardeningDisable = [ "format" ];

  strictDeps = true;

  # TODO: convert to __structuredAttrs
  preBuild = ''
    makeFlagsArray+=(
      INCS="-I${libX11.dev}/include -I${libXext.dev}/include -I${libXpm.dev}/include"
      LIBS="-L${libX11}/lib -L${libXext}/lib -L${libXpm}/lib -lX11 -lXpm -lXext"
    )
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ cputnik

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.dockapps.net/cputnik";
    description = "CPU and memory monitor";
    license = lib.licenses.gpl2Plus;
    mainProgram = "cputnik";
    inherit (windowmaker.meta) maintainers platforms;
  };
})
