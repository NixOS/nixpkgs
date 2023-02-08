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
      --prefix PATH : ${lib.makeBinPath (lib.optionals supportsLinuxDesktop [
          pkg-config
          cmake
          ninja
          clang
        ])} \
      --prefix PKG_CONFIG_PATH : "${
        let
          # https://discourse.nixos.org/t/handling-transitive-c-dependencies/5942/3
          deps = pkg: builtins.filter lib.isDerivation ((pkg.buildInputs or [ ]) ++ (pkg.propagatedBuildInputs or [ ]));
          collect = pkg: lib.unique ([ pkg ] ++ deps pkg ++ builtins.concatMap collect (deps pkg));
          libraries = builtins.concatMap (pkg: collect (lib.getOutput "dev" pkg)) (lib.optionals supportsLinuxDesktop[
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
            xorgproto
          ]);
          pkgconfigLib = builtins.filter (library: builtins.pathExists "${library}/lib/pkgconfig") libraries;
          pkgconfigShare = builtins.filter (library: builtins.pathExists "${library}/share/pkgconfig") libraries;
        in "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" pkgconfigLib}:${lib.makeSearchPathOutput "dev" "share/pkgconfig" pkgconfigShare}"}" \
      --prefix CXXFLAGS "''\t" '${lib.optionalString supportsLinuxDesktop "-isystem ${libX11.dev}/include -isystem ${xorgproto}/include"}' \
      --prefix LDFLAGS "''\t" '${lib.optionalString supportsLinuxDesktop "-rpath ${lib.makeLibraryPath [
          atk
          cairo
          gdk-pixbuf
          glib
          gtk3
          harfbuzz
          libepoxy
          pango
          libX11
        ]}"}' \
      --suffix LD_LIBRARY_PATH : '${lib.optionalString supportsLinuxDesktop (lib.makeLibraryPath [
          # The prebuilt flutter_linux_gtk library shipped in the Flutter SDK does not have an appropriate RUNPATH.
          # Its dependencies must be added here.
          libepoxy
        ])}' \
      --add-flags --no-version-check
''
