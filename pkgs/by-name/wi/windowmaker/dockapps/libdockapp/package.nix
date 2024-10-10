{
  lib,
  autoreconfHook,
  fontutil,
  libX11,
  libXext,
  libXpm,
  mkfontdir,
  pkg-config,
  stdenv,
  windowmaker,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdockapp";
  inherit (finalAttrs.src) version;

  src = windowmaker.dockapps.dockapps-sources;

  sourceRoot = "${finalAttrs.src.name}/libdockapp";

  nativeBuildInputs = [
    autoreconfHook
    fontutil
    mkfontdir
    pkg-config
  ];

  buildInputs = [
    libX11
    libXext
    libXpm
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  configureFlags = [
    (lib.withFeature false "examples")
    # There is a bug on --with-font
    (lib.withFeature false "font")
  ];

  meta = {
    description = "Library providing a framework for dockapps";
    homepage = "https://www.dockapps.net/libdockapp";
    license = lib.licenses.gpl2Plus;
    inherit (windowmaker.meta) maintainers platforms;
  };
})
