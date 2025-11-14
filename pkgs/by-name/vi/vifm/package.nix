{
  stdenv,
  fetchurl,
  makeWrapper,
  perl, # used to generate help tags
  pkg-config,
  ncurses,
  libX11,
  file,
  which,
  groff,

  # adds support for handling removable media (vifm-media). Linux only!
  mediaSupport ? false,
  python3 ? null,
  udisks ? null,
  lib ? null,
  gitUpdater,
}:

let
  isFullPackage = mediaSupport;
in
stdenv.mkDerivation rec {
  pname = if isFullPackage then "vifm-full" else "vifm";
  version = "0.14.3";

  src = fetchurl {
    url = "https://github.com/vifm/vifm/releases/download/v${version}/vifm-${version}.tar.bz2";
    hash = "sha256-Fqm+EQjWpaCen5R/clY3XlGbpB6+lHNlmyBzn9vzRA4=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    ncurses
    libX11
    file
    which
    groff
  ];

  postPatch = ''
    # Avoid '#!/usr/bin/env perl' references to build help.
    patchShebangs --build src/helpztags
  '';

  enableParallelBuilding = true;

  postFixup =
    let
      path = lib.makeBinPath [
        udisks
        (python3.withPackages (p: [ p.dbus-python ]))
      ];

      wrapVifmMedia = "wrapProgram $out/share/vifm/vifm-media --prefix PATH : ${path}";
    in
    ''
      ${lib.optionalString mediaSupport wrapVifmMedia}
    '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/vifm/vifm.git";
    rev-prefix = "v";
    ignoredVersions = "beta";
  };

  meta = {
    description = "Vi-like file manager${lib.optionalString isFullPackage "; Includes support for optional features"}";
    mainProgram = "vifm";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = if mediaSupport then lib.platforms.linux else lib.platforms.unix;
    license = lib.licenses.gpl2;
    downloadPage = "https://vifm.info/downloads.shtml";
    homepage = "https://vifm.info/";
    changelog = "https://github.com/vifm/vifm/blob/v${version}/ChangeLog";
  };
}
