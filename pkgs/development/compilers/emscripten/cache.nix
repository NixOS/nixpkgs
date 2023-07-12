{ emscriptenNoCache
, stdenvNoCC
, lndir
, lib
, emscriptenInheritCaches ? [ ]
, emscriptenCachePackages ? [ "SYSTEM" ]
, embuilderFlags ? [ ]
}:
let

  names = lib.concatStringsSep "-" emscriptenCachePackages;

  cache = stdenvNoCC.mkDerivation {
    pname = "emscripten-cache-${names}";
    version = emscriptenNoCache.version;

    passthru = {
      inherit asLibrary;
    };

    dontUnpack = true;

    buildPhase = ''
      runHook preBuild

      export EM_CACHE=$out/share/emscripten/cache
      mkdir -p $EM_CACHE

    '' + lib.concatStrings (map
      (base: ''
        cp --recursive ${base}/share/emscripten/cache/. $EM_CACHE
        chmod --recursive u+w $EM_CACHE
      '')
      emscriptenInheritCaches) + ''
      rm -f $EM_CACHE/cache.lock
    '' + lib.optionalString (emscriptenCachePackages != [ ]) ''
      ${emscriptenNoCache}/bin/embuilder.py build \
        ${lib.concatStringsSep " " embuilderFlags} \
        ${lib.concatStringsSep " " emscriptenCachePackages}
    '' + ''
      runHook postBuild;
    '';
  };

  asLibrary = emscriptenStdenv:
    assert emscriptenStdenv.hostPlatform.isEmscripten;
    emscriptenStdenv.mkDerivation {
      pname = if names == "" then "unknown" else names;
      version = "emscripten-${emscriptenNoCache.version}";
      passthru = {
        emscriptenCache = cache;
      };
      dontUnpack = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        find ${cache}/share/emscripten/cache/sysroot -type f | while read -r path; do
           install -D "$path" "$out/''${path#${cache}/share/emscripten/cache/sysroot/}"
        done
        runHook postInstall
      '';
    };

in
cache
