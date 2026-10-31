{
  lib,
  stdenv,
  dockapps-sources,
  libx11,
  libxpm,
  libxext,
  libdockapp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmcube";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/wmcube/wmcube";

  buildInputs = [
    libx11
    libxext
    libxpm
    libdockapp
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  preBuild = ''
        makeFlagsArray=(
          CC="${stdenv.cc.targetPrefix}cc"
          PREFIX="${placeholder "out"}"
          VERSION="${finalAttrs.version}"
          LIBDIR="-L${lib.getLib libx11}/lib -L${lib.getLib libxext}/lib \
    -L${lib.getLib libxpm}/lib -L${lib.getLib libdockapp}/lib"
          INCDIR="-I${lib.getDev libx11}/lib -I${lib.getDev libxext}/lib \
    -I${lib.getDev libxpm}/lib -I${lib.getDev libdockapp}/lib"
          LIBS="-lm -lXpm -lXext -lX11 -ldockapp"
        )
  '';

  preInstall = ''
    mkdir -pv $out/{bin,doc/wmcube-${finalAttrs.version},share/wmcube,man/man1}
  '';

  meta = {
    description = "System monitor for Windowmaker";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
