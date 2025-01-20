{
  lib,
  stdenv,
  racket,

  cairo,
  fontconfig,
  glib,
  glibcLocales,
  gtk3,
  libGL,
  libiodbc,
  libjpeg,
  libpng,
  makeFontsConf,
  pango,
  sqlite,
  unixODBC,
  wrapGAppsHook3,

  newScope,
  writeScript,
}:

let
  generateFromManifest = manifest: (_: __: builtins.mapAttrs (_: racket.makePackage) manifest);

  overrideStdenvAttrs =
    overlays: (_: prevPkgs: builtins.mapAttrs (key: prevPkgs.${key}.overrideAttrs) overlays);

  findPkgsFromDir =
    directory:
    (
      finalPkgs: _:
      lib.packagesFromDirectoryRecursive {
        inherit (finalPkgs) callPackage;
        inherit directory;
      }
    );

  cascade = [
    (generateFromManifest (lib.importJSON ./main-distribution.json))

    (overrideStdenvAttrs {
      draw-lib = prevAttrs: {
        propagatedBuildInputs = prevAttrs.propagatedBuildInputs or [ ] ++ [
          cairo
          fontconfig.lib
          glib
          libjpeg
          libpng
          pango
        ];

        setupHook = writeScript "racket-draw-lib-fontconfig-hook.sh" ''
          _racketDrawLibFontconfigHook() {
              if [[ ! -v FONTCONFIG_FILE ]]; then
                  export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ ]; }}
              fi

              if [[ ! ( -v XDG_CACHE_HOME || -d "$HOME/.cache" && -w "$HOME/.cache" ) ]]; then
                  export XDG_CACHE_HOME=$(mktemp -d)
              fi
          }

          addEnvHooks "$hostOffset" _racketDrawLibFontconfigHook
        '';
      };

      db-lib = prevAttrs: {
        propagatedBuildInputs = prevAttrs.propagatedBuildInputs or [ ] ++ [
          (if stdenv.hostPlatform.isDarwin then libiodbc else unixODBC)
          sqlite.out
        ];
      };

      gui-lib = prevAttrs: {
        propagatedBuildInputs = prevAttrs.propagatedBuildInputs or [ ] ++ [
          glib
          gtk3
          libGL
        ];

        propagatedNativeBuildInputs = prevAttrs.propagatedNativeBuildInputs or [ ] ++ [
          wrapGAppsHook3
        ];

        setupHook = writeScript "racket-gui-lib-locales-hook.sh" ''
          _racketGUILibLocalesHook() {
              if [[ ! -v gappsWrapperArgs ]]; then
                  declare -a gappsWrapperArgs
                  gappsWrapperArgs=()
              fi

              if [[ ! "''${gappsWrapperArgs[*]}" =~ "LOCALE_ARCHIVE" ]]; then
                  gappsWrapperArgs+=("--set" "LOCALE_ARCHIVE" "${glibcLocales}/lib/locale/locale-archive")
              fi
          }

          addEnvHooks "$hostOffset" _racketGUILibLocalesHook
        '';
      };
    })

    (generateFromManifest (lib.importJSON ./tests.json))

    (findPkgsFromDir ./packages)
  ];
in

(lib.makeScope newScope (_: { })).overrideScope (lib.composeManyExtensions cascade)
