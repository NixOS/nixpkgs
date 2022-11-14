{ version
, patches
, dart
, src
}:

{ lib
, git
, stdenv
, which
}:

stdenv.mkDerivation {
  name = "$flutter-${version}-unwrapped";

  buildInputs = [ git ];

  inherit src patches version;

  postPatch = ''
    patchShebangs --build ./bin/
  '';

  buildPhase = ''
    export FLUTTER_ROOT="$(pwd)"
    export FLUTTER_TOOLS_DIR="$FLUTTER_ROOT/packages/flutter_tools"
    export SCRIPT_PATH="$FLUTTER_TOOLS_DIR/bin/flutter_tools.dart"

    export SNAPSHOT_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot"
    export STAMP_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.stamp"

    export DART_SDK_PATH="${dart}"

    HOME=../.. # required for pub upgrade --offline, ~/.pub-cache
               # path is relative otherwise it's replaced by /build/flutter

    pushd "$FLUTTER_TOOLS_DIR"
    ${dart}/bin/dart pub get --offline
    popd

    local revision="$(cd "$FLUTTER_ROOT"; git rev-parse HEAD)"
    ${dart}/bin/dart --snapshot="$SNAPSHOT_PATH" --packages="$FLUTTER_TOOLS_DIR/.dart_tool/package_config.json" "$SCRIPT_PATH"
    echo "$revision" > "$STAMP_PATH"
    echo -n "${version}" > version

    rm -r bin/cache/{artifacts,dart-sdk,downloads}
    rm bin/cache/*.stamp
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out
    mkdir -p $out/bin/cache/
    ln -sf ${dart} $out/bin/cache/dart-sdk

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckInputs = [ which ];
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME="$(mktemp -d)"
    $out/bin/flutter config --android-studio-dir $HOME
    $out/bin/flutter config --android-sdk $HOME
    $out/bin/flutter --version | fgrep -q '${version}'

    runHook postInstallCheck
  '';

  passthru = {
    inherit dart;
  };

  meta = with lib; {
    description = "Flutter is Google's SDK for building mobile, web and desktop with Dart";
    longDescription = ''
      Flutter is Google’s UI toolkit for building beautiful,
      natively compiled applications for mobile, web, and desktop from a single codebase.
    '';
    homepage = "https://flutter.dev";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ babariviere ericdallo ];
  };
}
