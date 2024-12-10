{
  lib,
  mkDerivation,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  python3,
  vapoursynth,
  qmake,
  qtbase,
  qtwebsockets,
}:

let
  unwrapped = mkDerivation rec {
    pname = "vapoursynth-editor";
    version = "R19-mod-4";

    src = fetchFromGitHub {
      owner = "YomikoR";
      repo = pname;
      rev = lib.toLower version;
      sha256 = "sha256-+/9j9DJDGXbuTvE8ZXIu6wjcof39SyatS36Q6y9hLPg=";
    };

    nativeBuildInputs = [ qmake ];
    buildInputs = [
      qtbase
      vapoursynth
      qtwebsockets
    ];

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
      homepage = "https://github.com/YomikoR/VapourSynth-Editor";
      license = licenses.mit;
      maintainers = with maintainers; [ tadeokondrak ];
      platforms = platforms.all;
    };
  };

  withPlugins =
    plugins:
    let
      vapoursynthWithPlugins = vapoursynth.withPlugins plugins;
    in
    runCommand "${unwrapped.name}-with-plugins"
      {
        nativeBuildInputs = [ makeWrapper ];
        passthru = {
          withPlugins = plugins': withPlugins (plugins ++ plugins');
        };
      }
      ''
        mkdir -p $out/bin
        for bin in vsedit{,-job-server{,-watcher}}; do
            makeWrapper ${unwrapped}/bin/$bin $out/bin/$bin \
                --prefix PYTHONPATH : ${vapoursynthWithPlugins}/${python3.sitePackages} \
                --prefix LD_LIBRARY_PATH : ${vapoursynthWithPlugins}/lib
        done
      '';
in
withPlugins [ ]
