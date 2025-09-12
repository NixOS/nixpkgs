{
  lib,
  stdenv,
  fetchzip,
  perl,
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

  objectbox-c = fetchzip {
    # version is kept in sync by upstream, https://github.com/objectbox/objectbox-dart/blob/befffe65689f596edb5494a41998bba60a0fd3b6/flutter_libs/linux/CMakeLists.txt#L47
    url = "https://github.com/objectbox/objectbox-c/releases/download/v${version}/objectbox-linux-${arch}.tar.gz";
    name = "objectbox-linux-${version}";
    hash = selectSystem {
      x86_64-linux = "sha256-FuA/q81x04YjxKhln5DFKWOoTw2x4hKegaWfKZe0Z1k=";
      aarch64-linux = "sha256-yJ5Hf2svRSlmtNS+OVnI5s81+7LQMGy22q6c+vCWcnQ=";
    };
    stripRoot = false;
    meta.license = lib.licenses.unfree; # the release tarball has a proprietary shared library
  };
in
stdenv.mkDerivation {
  pname = "objectbox_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  nativeBuildInputs = [ perl ];
  patchPhase = ''
    runHook prePatch

    # patch the cmakelists.txt file, independent of the version

    # remove the objectbox-c download section
    perl -0pe 's/set\(OBJECTBOX_VERSION.*?FetchContent_Populate\(objectbox-download\).*?endif\(\)//gs' -i linux/CMakeLists.txt
    # replace the shared library path
    substituteInPlace linux/CMakeLists.txt \
    --replace-fail '"''${objectbox-download_SOURCE_DIR}/lib/''${CMAKE_SHARED_LIBRARY_PREFIX}objectbox''${CMAKE_SHARED_LIBRARY_SUFFIX}"' '"${objectbox-c}/lib/libobjectbox.so"'

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta.sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
}
