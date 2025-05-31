{
  lib,
  stdenv,
  fetchzip,
  replaceVars,
}:

{ version, src, ... }:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system}
      or (throw "objectbox_flutter_libs: ${stdenv.hostPlatform.system} is not supported");

  arch = selectSystem {
    x86_64-linux = "x64";
    aarch64-linux = "aarch64";
  };

  objectbox-sync = fetchzip {
    url = "https://github.com/objectbox/objectbox-c/releases/download/v4.0.2/objectbox-sync-linux-${arch}.tar.gz";
    hash = selectSystem {
      x86_64-linux = "sha256-VXTuCYg0ZItK+lAs7xkNlxO0rUPnbRZOP5RAXbcRyjM=";
      aarch64-linux = "sha256-kNlrBRR/qDEhdU34f4eDQLgYkYAIfFC8/of4rgL+m6k=";
    };
    stripRoot = false;
  };
in
stdenv.mkDerivation {
  pname = "objectbox_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  patches = [
    (replaceVars ./CMakeLists.patch {
      OBJECTBOX_SHARED_LIBRARY = "${objectbox-sync}/lib/libobjectbox.so";
    })
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta.sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
}
