{ lib
, stdenv
, fetchurl
, installShellFiles
, lesstif
, libX11
, libXext
, libXinerama
, libXmu
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yeahwm";
  version = "0.3.5";

  src = fetchurl {
    url = "http://phrat.de/yeahwm_${finalAttrs.version}.tar.gz";
    hash = "sha256-ySzpiEjIuI2bZ8Eo4wcQlEwEpkVDECVFNcECsrb87gU=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    lesstif
    libX11
    libXext
    libXinerama
    libXmu
  ];

  strictDeps = true;

  preBuild = let
    includes = builtins.concatStringsSep " "
      (builtins.map (l: "-I${lib.getDev l}/include")
        finalAttrs.buildInputs);
    ldpath = builtins.concatStringsSep " "
      (builtins.map (l: "-L${lib.getLib l}/lib")
        finalAttrs.buildInputs);
  in ''
    makeFlagsArray+=( CC="${stdenv.cc}/bin/cc" \
                      XROOT="${libX11}" \
                      INCLUDES="${includes}" \
                      LDPATH="${ldpath}" \
                      prefix="${placeholder "out"}" )
  '';

  # Workaround build failure on -fno-common toolchains like upstream gcc-10.
  # Otherwise build fails as:
  #   ld: screen.o:(.bss+0x40): multiple definition of `fg'; client.o:(.bss+0x40): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postInstall = ''
    installManPage yeahwm.1
  '';

  meta = {
    homepage = "http://phrat.de/index.html";
    description = "An X window manager based on evilwm and aewm";
    longDescription = ''
      YeahWM is a h* window manager for X based on evilwm and aewm.

      Features
      - Sloppy Focus.
      - BeOS-like tabbed titles, which can be repositioned.
      - Support for Xinerama.
      - Simple Appearance.
      - Good keyboard control.
      - Creative usage of the mouse.
      - Respects aspect size hints.
      - Solid resize and move operations.
      - Virtual Desktops.
      - "Magic" Screen edges for desktop switching.
      - Snapping to other windows and screen borders when moving windows.
      - Small binary size(ca. 23kb).
      - Little resource usage.
      - It's slick.
    '';
    changelog = "http://phrat.de/README";
    license = lib.licenses.isc;
    mainProgram = "yeahwm";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
