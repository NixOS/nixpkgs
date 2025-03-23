{
  lib,
  stdenv,
  dockapps-sources,
  libX11,
  libXpm,
  libXext,
  libdockapp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmcube";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/wmcube/wmcube";

  buildInputs = [
    libX11
    libXext
    libXpm
    libdockapp
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  preBuild = ''
        makeFlagsArray=(
          CC="${stdenv.cc.targetPrefix}cc"
          PREFIX="${placeholder "out"}"
          VERSION="${finalAttrs.version}"
          LIBDIR="-L${lib.getLib libX11}/lib -L${lib.getLib libXext}/lib \
    -L${lib.getLib libXpm}/lib -L${lib.getLib libdockapp}/lib"
          INCDIR="-I${lib.getDev libX11}/lib -I${lib.getDev libXext}/lib \
    -I${lib.getDev libXpm}/lib -I${lib.getDev libdockapp}/lib"
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
