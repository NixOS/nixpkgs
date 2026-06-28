{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  python3,
  vapoursynth,
  qt6,
}:

let
  unwrapped = stdenv.mkDerivation rec {
    pname = "vapoursynth-editor";
    version = "R19-mod-6.8";

    src = fetchFromGitHub {
      owner = "YomikoR";
      repo = "vapoursynth-editor";
      tag = version;
      hash = "sha256-eSdyhKRNsZeSRqkn5SzbB5YRuKehgCJD03PYiD5zQ/Y=";
    };

    postPatch = ''
      substituteInPlace pro/vsedit/vsedit.pro \
        --replace-fail "TARGET = vsedit-32bit" "TARGET = vsedit"
    '';

    nativeBuildInputs = [
      qt6.qmake
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      qt6.qtbase
      vapoursynth
      qt6.qtwebsockets
      qt6.qt5compat
    ];

    # ../../common-src/helpers.h:4:10: fatal error: VapourSynth4.h: No such file or directory
    env.NIX_CFLAGS_COMPILE = "-I${lib.getInclude vapoursynth}/include/vapoursynth";

    dontWrapQtApps = true;

    preConfigure = "cd pro";

    preFixup = ''
      cd ../build/release*
      mkdir -p $out/bin
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      for bin in vsedit{,-job-server{,-watcher}}; do
          mv $bin.app $out/Applications
          makeQtWrapper $out/Applications/$bin.app/Contents/MacOS/$bin $out/bin/$bin
          wrapQtApp $out/Applications/$bin.app/Contents/MacOS/$bin
      done
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      for bin in vsedit{,-job-server{,-watcher}}; do
          mv $bin $out/bin
          wrapQtApp $out/bin/$bin
      done
    '';

    passthru = {
      inherit withPlugins;
    };

    meta = {
      description = "Cross-platform editor for VapourSynth scripts";
      homepage = "https://github.com/YomikoR/VapourSynth-Editor";
      license = lib.licenses.mit;
      maintainers = [ ];
      platforms = lib.platforms.all;
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
