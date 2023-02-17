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
  linuxDesktopRuntimeDeps = [
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

  linuxDesktopBuildDeps = let
    # https://discourse.nixos.org/t/handling-transitive-c-dependencies/5942/3
    deps = pkg: builtins.filter lib.isDerivation ((pkg.buildInputs or [ ]) ++ (pkg.propagatedBuildInputs or [ ]));
    collect = pkg: lib.unique ([ pkg ] ++ deps pkg ++ builtins.concatMap collect (deps pkg));
  in builtins.concatMap collect linuxDesktopRuntimeDeps;
in
runCommandLocal "flutter"
{
  flutterWithCorrectedCache = writeShellScript "flutter_corrected_cache" ''
    export PUB_CACHE=''${PUB_CACHE:-"$HOME/.pub-cache"}
    ${flutter}/bin/flutter "$@"
  '';

  buildInputs = [ makeWrapper ];

  passthru = flutter.passthru // {
    unwrapped = flutter;
  };

  inherit (flutter) meta;
} ''
  mkdir -p $out/bin

  mkdir -p $out/bin/cache/
  ln -sf ${flutter.dart} $out/bin/cache/dart-sdk

  makeWrapper "$flutterWithCorrectedCache" $out/bin/flutter \
      --set-default ANDROID_EMULATOR_USE_SYSTEM_LIBS 1 \
      --prefix PATH : '${lib.makeBinPath (lib.optionals supportsLinuxDesktop [
          pkg-config
          cmake
          ninja
          clang
        ])}' \
      --prefix PKG_CONFIG_PATH : '${
        let
          makePkgConfigSearchPath = pkgs: builtins.concatStringsSep ":" (builtins.filter builtins.pathExists (builtins.concatMap (pkg: map (dir: "${lib.getOutput "dev" pkg}/${dir}/pkgconfig") [ "lib" "share" ]) pkgs));
        in makePkgConfigSearchPath linuxDesktopBuildDeps}' \
      --prefix CXXFLAGS "''\t" '${lib.optionalString supportsLinuxDesktop "-isystem ${libX11.dev}/include -isystem ${xorgproto}/include"}' \
      ${let linkerFlags = map (pkg: "-rpath,${lib.getOutput "lib" pkg}/lib") (lib.optionals supportsLinuxDesktop linuxDesktopRuntimeDeps); in ''
        --prefix LDFLAGS "''\t" '${builtins.concatStringsSep " " (map (flag: "-Wl,${flag}") linkerFlags)}' \
      ''} \
      --suffix LD_LIBRARY_PATH : '${lib.optionalString supportsLinuxDesktop (lib.makeLibraryPath [
          # The prebuilt flutter_linux_gtk library shipped in the Flutter SDK does not have an appropriate RUNPATH.
          # Its dependencies must be added here.
          libepoxy
        ])}' \
      --add-flags --no-version-check
''
