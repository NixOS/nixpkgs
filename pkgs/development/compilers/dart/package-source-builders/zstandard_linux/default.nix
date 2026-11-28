{
  lib,
  stdenv,
}:

{ version, src, ... }:

let
  bundledLibraries =
    {
      _1_5_0 = "$<TARGET_FILE:zstandard_linux>";
    }
    .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
      Unsupported version of pub 'zstandard_linux': '${version}'
      Please add bundledLibraries here. If the bundled libraries
      are the same with existing versions, add an alias here.
    '');
in
stdenv.mkDerivation {
  pname = "zstandard_linux";
  inherit version src;
  inherit (src) passthru;

  # The plugin links against a shared zstd library, but does not bundle it into
  # the application, which leaves the library unresolvable at runtime.
  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail $'set(zstandard_linux_bundled_libraries\n  ""' \
      $'set(zstandard_linux_bundled_libraries\n  "${bundledLibraries}"'
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
