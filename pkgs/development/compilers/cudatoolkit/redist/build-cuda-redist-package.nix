{
  autoAddOpenGLRunpathHook,
  autoPatchelfHook,
  backendStdenv,
  cudaFlags,
  cudaVersion,
  fetchurl,
  lib,
  stdenv,
}: pname: attrs: let
  inherit (lib) attrsets lists strings trivial;
  arch = "linux-x86_64";

  # unsupportedCapabilities :: List Capability
  unsupportedCapabilities =
    lists.filter
    (computeCapability: !lists.elem computeCapability cudaFlags.cudaSupportedCapabilities)
    cudaFlags.cudaCapabilities;

  # broken :: Bool
  broken = let
    isBroken = unsupportedCapabilities != [];
  in
    trivial.warnIf
    isBroken
    ''
      CUDA ${cudaVersion} supports the following capabilities:
        ${strings.concatStringsSep ", " cudaFlags.cudaSupportedCapabilities}
      However, the following unsupported capabilities were requested:
        ${strings.concatStringsSep ", " unsupportedCapabilities}
      This means that packages relying on this version of CUDA are not available.
      If possible, consider upgrading to a newer version of CUDA.
    ''
    isBroken;
in
  backendStdenv.mkDerivation {
    inherit pname;
    inherit (attrs) version;

    src = fetchurl {
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
      # autoPatchelfHook will search for a libstdc++ and we're giving it
      # one that is compatible with the rest of nixpkgs, even when
      # nvcc forces us to use an older gcc
      # NB: We don't actually know if this is the right thing to do
      stdenv.cc.cc.lib
    ];

    # Picked up by autoPatchelf
    # Needed e.g. for libnvrtc to locate (dlopen) libnvrtc-builtins
    appendRunpaths = [
      "$ORIGIN"
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

    passthru.stdenv = backendStdenv;

    meta = {
      inherit broken;
      description = attrs.name;
      license = lib.licenses.unfree;
      maintainers = lib.teams.cuda.members;
      platforms = lists.optionals (attrsets.hasAttr arch attrs) ["x86_64-linux"];
    };
  }
