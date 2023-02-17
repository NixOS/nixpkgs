{ lib
, stdenv
, callPackage
, flutter
, supportsLinuxDesktop ? stdenv.isLinux
, makeWrapper
, runCommandLocal
, writeShellScript
, pkg-config
, atk
, cairo
, gdk-pixbuf
, glib
, gtk3
, harfbuzz
, libepoxy
, pango
, libX11
, xorgproto
, cmake
, ninja
, clang
}:

let
  # By default, Flutter stores downloaded files (such as the Pub cache) in the SDK directory.
  # Wrap it to ensure that it does not do that, preferring home directories instead.
  immutableFlutter = writeShellScript "flutter_immutable" ''
    export PUB_CACHE=''${PUB_CACHE:-"$HOME/.pub-cache"}
    ${flutter}/bin/flutter --no-version-check "$@"
  '';

  # Libraries that Flutter apps depend on at runtime.
  appRuntimeDeps = lib.optionals supportsLinuxDesktop [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libepoxy
    pango
    libX11
    (callPackage ./packages/libdeflate { })
  ];

  # Development packages required for compilation.
  appBuildDeps =
    let
      # https://discourse.nixos.org/t/handling-transitive-c-dependencies/5942/3
      deps = pkg: builtins.filter lib.isDerivation ((pkg.buildInputs or [ ]) ++ (pkg.propagatedBuildInputs or [ ]));
      collect = pkg: lib.unique ([ pkg ] ++ deps pkg ++ builtins.concatMap collect (deps pkg));
    in
    builtins.concatMap collect appRuntimeDeps;

  # Some header files are not properly located by the Flutter SDK.
  # They must be manually included.
  appStaticBuildDeps = lib.optionals supportsLinuxDesktop [ libX11 xorgproto ];

  # Some runtime components are prebuilt, and do not know where to find their dependencies.
  # Ideally, these prebuilt components would be patched by the SDK derivation, but this
  # is tricky as they are tyically downloaded from Google on-demand.
  # Building the Engine manually should solve this issue: https://github.com/NixOS/nixpkgs/issues/201574
  appPrebuiltDeps = lib.optionals supportsLinuxDesktop [
    # flutter_linux_gtk.so
    libepoxy
  ];

  # Tools used by the Flutter SDK to compile applications.
  buildTools = lib.optionals supportsLinuxDesktop [
    pkg-config
    cmake
    ninja
    clang
  ];

  # Nix-specific compiler configuration.
  pkgConfigDirectories = builtins.filter builtins.pathExists (builtins.concatMap (pkg: map (dir: "${lib.getOutput "dev" pkg}/${dir}/pkgconfig") [ "lib" "share" ]) appBuildDeps);
  cppFlags = map (pkg: "-isystem ${lib.getOutput "dev" pkg}/include") appStaticBuildDeps;
  linkerFlags = map (pkg: "-rpath,${lib.getOutput "lib" pkg}/lib") appRuntimeDeps;
in
runCommandLocal "flutter"
{
  buildInputs = [ makeWrapper ];

  passthru = flutter.passthru // {
    unwrapped = flutter;
  };

  inherit (flutter) meta;
} ''
  mkdir -p $out/bin

  mkdir -p $out/bin/cache/
  ln -sf ${flutter.dart} $out/bin/cache/dart-sdk

  makeWrapper '${immutableFlutter}' $out/bin/flutter \
    --set-default ANDROID_EMULATOR_USE_SYSTEM_LIBS 1 \
    --prefix PATH : '${lib.makeBinPath buildTools}' \
    --prefix PKG_CONFIG_PATH : '${builtins.concatStringsSep ":" pkgConfigDirectories}' \
    --prefix CXXFLAGS "''\t" '${builtins.concatStringsSep " " cppFlags}' \
    --prefix LDFLAGS "''\t" '${builtins.concatStringsSep " " (map (flag: "-Wl,${flag}") linkerFlags)}' \
    --suffix LD_LIBRARY_PATH : '${lib.makeLibraryPath appPrebuiltDeps}'
''
