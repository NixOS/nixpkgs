{
  lib,
  fetchzip,
}:

{ version, src, ... }:

let
  # Pub version -> prebuilt artifact version (from version.txt) and hash.
  # Artifacts: https://rive-flutter-artifacts.rive.app/rive_native_versions/<ver>/rive_native_artifacts_linux.zip
  artifactMeta =
    {
      "0.1.5" = {
        artifactVersion = "0.1.5+1";
        hash = "sha256-83zml7i4XmW3PaTI3VY74YcBt4bnmgGguWPA3KNhEoI=";
      };
    }
    .${version} or (throw ''
      Unsupported version of pub 'rive_native': '${version}'
      Please add artifactVersion/hash for Linux prebuilts in
      pkgs/development/compilers/dart/package-source-builders/rive_native.
    '');

  artifacts = fetchzip {
    url = "https://rive-flutter-artifacts.rive.app/rive_native_versions/${
      builtins.replaceStrings [ "+" ] [ "%2B" ] artifactMeta.artifactVersion
    }/rive_native_artifacts_linux.zip";
    inherit (artifactMeta) hash;
    stripRoot = false;
  };
in
src.overrideAttrs (old: {
  buildCommand = ''
    ${old.buildCommand or ""}
    chmod -R u+w "$out"
    # layout expected by linux/CMakeLists.txt: linux/bin/lib/release/*.a
    mkdir -p "$out/linux/bin"
    cp -r ${artifacts}/. "$out/linux/bin/"
    # Skip `dart run rive_native:setup` (network) during CMake; libs are vendored.
    touch "$out/linux/rive_marker_linux_development"
  '';

  meta = (old.meta or { }) // {
    description = "Rive native runtime prebuilts for Flutter (Linux)";
    homepage = "https://pub.dev/packages/rive_native";
    # Vendored static libraries from rive-flutter-artifacts.rive.app
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.mit;
  };
})
