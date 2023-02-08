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

  buildInputs = [
    makeWrapper
    pkg-config
  ] ++ lib.lists.optionals supportsLinuxDesktop (
    let
      # https://discourse.nixos.org/t/handling-transitive-c-dependencies/5942/3
      deps = pkg: (pkg.buildInputs or [ ]) ++ (pkg.propagatedBuildInputs or [ ]);
      collect = pkg: lib.unique ([ pkg ] ++ deps pkg ++ lib.concatMap collect (deps pkg));
    in
    collect atk.dev ++
      collect cairo.dev ++
      collect gdk-pixbuf.dev ++
      collect glib.dev ++
      collect gtk3.dev ++
      collect harfbuzz.dev ++
      collect libepoxy.dev ++
      collect pango.dev ++
      collect libX11.dev ++
      collect (callPackage ./packages/libdeflate { }).dev ++
      collect xorgproto
  );

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
      --prefix PATH : ${lib.makeBinPath (lib.lists.optionals supportsLinuxDesktop [
          pkg-config
          cmake
          ninja
          clang
        ])} \
      --prefix PKG_CONFIG_PATH : "$PKG_CONFIG_PATH_FOR_TARGET" \
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
