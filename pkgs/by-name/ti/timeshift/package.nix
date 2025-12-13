{
  lib,
  stdenvNoCC,
  timeshift-unwrapped,
  wrapGAppsHook3,
  gdk-pixbuf,
  librsvg,
  lndir,
  shared-mime-info,
  runtimeDeps ? [ ],
}:
stdenvNoCC.mkDerivation {
  pname = "timeshift";
  inherit (timeshift-unwrapped) version outputs;

  dontUnpack = true;

  nativeBuildInputs = [
    wrapGAppsHook3
    lndir
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.concatMapStrings (outputName: ''
    mkdir -p "''$${outputName}"
    lndir -silent "${timeshift-unwrapped.${outputName}}" "''$${outputName}"
  '') timeshift-unwrapped.outputs
  + ''
    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs=(
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    )
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${
        lib.makeSearchPath "share" [
          gdk-pixbuf
          librsvg
          shared-mime-info
        ]
      }"
      "''${makeWrapperArgs[@]}"
    )
    wrapProgram "$out/bin/timeshift" "''${makeWrapperArgs[@]}"
    wrapProgram "$out/bin/timeshift-gtk" "''${gappsWrapperArgs[@]}"
    # Substitute app_command to look for the `timeshift-gtk` in $out.
    unlink "$out/bin/timeshift-launcher"
    substitute ${lib.getExe' timeshift-unwrapped "timeshift-launcher"} "$out/bin/timeshift-launcher" \
      --replace-fail "app_command=${lib.getExe' timeshift-unwrapped "timeshift-gtk"}" "app_command=$out/bin/timeshift-gtk"
    chmod +x "$out/bin/timeshift-launcher"
  '';

  meta =
    let
      minimal = runtimeDeps == [ ];
      runtimeDepsStr = lib.pipe runtimeDeps [
        (lib.map lib.getName)
        lib.reverseList
        (
          p:
          lib.pipe p [
            lib.tail
            lib.reverseList
            (lib.concatStringsSep ", ")
          ]
          + " and "
          + lib.head p
        )
      ];
    in
    timeshift-unwrapped.meta
    // {
      description =
        timeshift-unwrapped.meta.description + lib.optionalString minimal " (without runtime dependencies)";

      longDescription =
        timeshift-unwrapped.meta.longDescription
        + "This package is a wrapped version of timeshift-unwrapped with"
        + lib.optionalString minimal "out"
        + " command line utility runtime dependencies"
        + lib.optionalString (!minimal) " from ${runtimeDepsStr}"
        + "."
        + lib.optionalString (!minimal) ''

          If you want to use the commands provided by the system, use timeshift-minimal instead.
        '';
    };
}
