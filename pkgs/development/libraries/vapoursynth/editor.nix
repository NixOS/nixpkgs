{ lib, mkDerivation, fetchFromBitbucket, makeWrapper, runCommand
, python3, vapoursynth
, qmake, qtbase, qtwebsockets
}:

let
  unwrapped = mkDerivation rec {
    pname = "vapoursynth-editor";
    version = "R19";

    src = fetchFromBitbucket {
      owner = "mystery_keeper";
      repo = pname;
      rev = lib.toLower version;
      sha256 = "1zlaynkkvizf128ln50yvzz3b764f5a0yryp6993s9fkwa7djb6n";
    };

    nativeBuildInputs = [ qmake ];
    buildInputs = [ qtbase vapoursynth qtwebsockets ];

    dontWrapQtApps = true;

    preConfigure = "cd pro";

    preFixup = ''
      cd ../build/release*
      mkdir -p $out/bin
      for bin in vsedit{,-job-server{,-watcher}}; do
          mv $bin $out/bin
          wrapQtApp $out/bin/$bin
      done
    '';

    passthru = { inherit withPlugins; };

    meta = with lib; {
      description = "Cross-platform editor for VapourSynth scripts";
      homepage = "https://bitbucket.org/mystery_keeper/vapoursynth-editor";
      license = licenses.mit;
      maintainers = with maintainers; [ tadeokondrak ];
      platforms = platforms.all;
    };
  };

  withPlugins = plugins: let
    vapoursynthWithPlugins = vapoursynth.withPlugins plugins;
  in runCommand "${unwrapped.name}-with-plugins" {
    buildInputs = [ makeWrapper ];
    passthru = { withPlugins = plugins': withPlugins (plugins ++ plugins'); };
  } ''
    mkdir -p $out/bin
    for bin in vsedit{,-job-server{,-watcher}}; do
        makeWrapper ${unwrapped}/bin/$bin $out/bin/$bin \
            --prefix PYTHONPATH : ${vapoursynthWithPlugins}/${python3.sitePackages} \
            --prefix LD_LIBRARY_PATH : ${vapoursynthWithPlugins}/lib
    done
  '';
in
  withPlugins []
