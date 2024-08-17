{
  lib,
  libX11,
  libXext,
  libXpm,
  stdenv,
  windowmaker,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmcube";
  inherit (windowmaker.dockapps.dockapps-sources) version;

  src = windowmaker.dockapps.dockapps-sources;

  sourceRoot = "${finalAttrs.src.name}/wmcube/wmcube";

  buildInputs = [
    libX11
    libXext
    libXpm
    windowmaker.dockapps.libdockapp
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  postPatch = ''
    substituteInPlace wmcube.c \
      --replace-fail "/usr/share/wmcube/" "$out/share/wmcube/"
  '';

  preBuild = ''
    makeFlagsArray+=(
      CC="${stdenv.cc.targetPrefix}cc"
      PREFIX="${placeholder "out"}"
      BINDIR=''${!outputBin}/bin
      MANDIR=''${!outputMan}/share/man/man1
      DOCDIR=''${!outputDoc}/share/doc/wmcube-${finalAttrs.version}
      VERSION="${finalAttrs.version}"
      LIBDIR="-L${lib.getLib libX11}/lib -L${lib.getLib libXext}/lib \
    -L${lib.getLib libXpm}/lib -L${lib.getLib windowmaker.dockapps.libdockapp}/lib"
      INCDIR="-I${lib.getDev libX11}/lib -I${lib.getDev libXext}/lib \
    -I${lib.getDev libXpm}/lib -I${lib.getDev windowmaker.dockapps.libdockapp}/lib"
      LIBS="-lm -lXpm -lXext -lX11 -ldockapp"
    )
  '';

  preInstall = ''
    mkdir -pv ''${!outputBin}/bin \
              ''${!outputMan}/share/man/man1 \
              ''${!outputDoc}/share/doc/wmcube-${finalAttrs.version}
  '';

  meta = {
    homepage = "https://www.dockapps.net/wmcube";
    description = "Show a rotating 3D object";
    longDescription = ''
      wmcube is a dockapp displaying a realtime rotating 3D object (plugin)
      together with the current CPU load.  The speed of the rotation depends on
      the CPU load.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "wmcube";
    inherit (windowmaker.meta) maintainers platforms;
  };
})
