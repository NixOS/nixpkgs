{ arcan
, makeWrapper
, symlinkJoin
, appls ? [ ]
, name ? "arcan-wrapped"
}:

symlinkJoin rec {
  inherit name;

  paths = appls ++ [ arcan ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for prog in ${placeholder "out"}/bin/*; do
      wrapProgram $prog \
        --prefix PATH ":" "${placeholder "out"}/bin" \
        --set ARCAN_APPLBASEPATH "${placeholder "out"}/share/arcan/appl/" \
        --set ARCAN_BINPATH "${placeholder "out"}/bin/arcan_frameserver" \
        --set ARCAN_LIBPATH "${placeholder "out"}/lib/" \
        --set ARCAN_RESOURCEPATH "${placeholder "out"}/share/arcan/resources/" \
        --set ARCAN_SCRIPTPATH "${placeholder "out"}/share/arcan/scripts/" \
        --set ARCAN_STATEBASEPATH "\$HOME/.arcan/resources/savestates/"
    done
  '';
}
# TODO: set ARCAN_FONTPATH to a set of fonts that can be provided in a parameter
