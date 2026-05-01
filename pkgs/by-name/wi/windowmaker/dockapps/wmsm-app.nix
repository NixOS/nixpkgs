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
  pname = "wmsm.app";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/wmsm.app/wmsm";

  buildInputs = [
    libX11
    libXext
    libXpm
    libdockapp
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "PREFIX	= /usr/X11R6/bin" "" \
      --replace "/usr/bin/install" "install"
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall
    install -d ${placeholder "out"}/bin
    runHook postInstall
  '';

  installFlags = [
    "PREFIX=${placeholder "out"}/bin"
  ];

  meta = {
    description = "System monitor for Windowmaker";
    homepage = "https://www.dockapps.net/wmsmapp";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
