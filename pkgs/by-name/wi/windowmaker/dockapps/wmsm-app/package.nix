{
  lib,
  libX11,
  libXext,
  libXpm,
  stdenv,
  windowmaker,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmsm.app";
  inherit (finalAttrs.src) version;

  src = windowmaker.dockapps.dockapps-sources;

  sourceRoot = "${finalAttrs.src.name}/wmsm.app/wmsm";

  buildInputs = [
    libX11
    libXext
    libXpm
    windowmaker.dockapps.libdockapp
  ];

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "PREFIX	= /usr/X11R6/bin" "" \
      --replace "/usr/bin/install" "install"
  '';

  preBuild = ''
    makeFlagsArray+=(
      CC="${stdenv.cc.targetPrefix}cc"
      PREFIX="${placeholder "out"}"
      LIBDIR="-L${lib.getLib libX11}/lib -L${lib.getLib libXext}/lib \
    -L${lib.getLib libXpm}/lib -L${lib.getLib windowmaker.dockapps.libdockapp}/lib"
      INCDIR="-I${lib.getDev libX11}/lib -I${lib.getDev libXext}/lib \
    -I${lib.getDev libXpm}/lib -I${lib.getDev windowmaker.dockapps.libdockapp}/lib"
      LIBS="-lm -lXpm -lXext -lX11 -ldockapp"
    )
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv ''${!outputBin}/bin/

    install -Dm755 -T wmsm ''${!outputBin}/bin/wmsm

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.dockapps.net/wmsmapp";
    description = "System monitor for Windowmaker";
    license = lib.licenses.gpl2Plus;
    mainProgram = "wmsm";
    inherit (windowmaker.meta) maintainers platforms;
  };
})
