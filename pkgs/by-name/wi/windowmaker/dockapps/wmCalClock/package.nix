{
  lib,
  installShellFiles,
  libX11,
  libXext,
  libXpm,
  stdenv,
  windowmaker,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmCalClock";
  inherit (windowmaker.dockapps.dockapps-sources) version;

  src = windowmaker.dockapps.dockapps-sources;

  sourceRoot = "${finalAttrs.src.name}/wmCalClock/Src";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    libX11
    libXext
    libXpm
  ];

  outputs = [
    "out"
    "man"
  ];

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  # TODO: convert to __structuredAttrs
  preBuild = ''
    makeFlagsArray+=(
      CC="${stdenv.cc.targetPrefix}cc"
      INCDIR="-I${libX11.dev}/include -I${libXext.dev}/include -I${libXpm.dev}/include"
      LIBDIR="-I${libX11}/lib -I${libXext}/lib -I${libXpm}/lib"
    )
  '';

  # install target from Makefile is not good...
  installPhase = ''
    runHook preInstall

    install -Dm755 wmCalClock -t ${placeholder "out"}/bin
    installManPage wmCalClock.1

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.dockapps.net/wmcalclock";
    description = "Calendar clock with antialiased text";
    license = lib.licenses.gpl2Plus;
    mainProgram = "wmCalClock";
    inherit (windowmaker.meta) maintainers platforms;
  };
})
