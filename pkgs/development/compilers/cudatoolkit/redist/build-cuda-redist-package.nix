{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, autoAddOpenGLRunpathHook
}:

pname:
attrs:

let
  # (concatStringsSep "-") after reverseList after (split "-")
  nixToNvidia = {
    "x86_64-linux" = "linux-x86_64";
    "aarch64-linux" = "linux-aarch64";
  };

  # Intersection of nixToNvidia and the manifest
  distributedPlatforms = lib.filterAttrs
    (nixArch: nvArch: builtins.hasAttr nvArch attrs)
    nixToNvidia;

  # Not evaluated unless hostPlatform is in the meta.platforms list
  arch = nixToNvidia.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  inherit pname;
  inherit (attrs) version;

  src = assert (lib.hasAttr arch attrs); fetchurl {
    url = "https://developer.download.nvidia.com/compute/cuda/redist/${attrs.${arch}.relative_path}";
    inherit (attrs.${arch}) sha256;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    # This hook will make sure libcuda can be found
    # in typically /lib/opengl-driver by adding that
    # directory to the rpath of all ELF binaries.
    # Check e.g. with `patchelf --print-rpath path/to/my/binary
    autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  dontBuild = true;

  # TODO: choose whether to install static/dynamic libs
  installPhase = ''
    runHook preInstall
    rm LICENSE
    mkdir -p $out
    mv * $out
    runHook postInstall
  '';

  meta = {
    description = attrs.name;
    license = lib.licenses.unfree;
    platforms = lib.attrNames distributedPlatforms;
  };
}
