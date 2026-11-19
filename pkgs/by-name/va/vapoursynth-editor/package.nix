{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  python3Packages,
  qt6,
}:

let
  inherit (python3Packages) vapoursynth;
  vsPath = "${vapoursynth}/${vapoursynth.pythonModule.sitePackages}/vapoursynth";
in

stdenv.mkDerivation rec {
  pname = "vapoursynth-editor";
  version = "R19-mod-6.10";

  src = fetchFromGitHub {
    owner = "YomikoR";
    repo = "vapoursynth-editor";
    tag = version;
    hash = "sha256-T2pp1kXXc4mvTSKnjRp55xSkJs2jl70JqzshPvyrUIk=";
  };

  patches = [
    ./hardcode-libvsscript.patch
  ];

  postPatch = ''
    export vsscriptPath='${vsPath}/libvsscript.so'
    substituteInPlace pro/vsedit/vsedit.pro \
      --replace-fail "TARGET = vsedit-32bit" "TARGET = vsedit"
    substituteAllInPlace common-src/vapoursynth/vs_script_library.cpp
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

  env.VS_INCLUDE_PATH = "${vsPath}/include";
  preConfigure = "cd pro";

  dontWrapQtApps = true;
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

  # Make it a python package, so it can be added to python3.withPackages
  passthru.pythonModule = vapoursynth.pythonModule;
  passthru.requiredPythonModules = [ vapoursynth ];

  meta = {
    description = "Cross-platform editor for VapourSynth scripts";
    homepage = "https://github.com/YomikoR/VapourSynth-Editor";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
