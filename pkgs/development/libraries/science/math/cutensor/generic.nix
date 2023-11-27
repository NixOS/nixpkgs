{ stdenv
, lib
, libPath
, cuda_cudart
, cudaMajorVersion
, cuda_nvcc
, cudatoolkit
, libcublas
, fetchurl
, autoPatchelfHook
, addOpenGLRunpath

, version
, hash
}:

let
  mostOfVersion = builtins.concatStringsSep "."
    (lib.take 3 (lib.versions.splitVersion version));
  platform = "${stdenv.hostPlatform.parsed.kernel.name}-${stdenv.hostPlatform.parsed.cpu.name}";
in

stdenv.mkDerivation {
  pname = "cutensor-cu${cudaMajorVersion}";
  inherit version;

  src = fetchurl {
    url = if lib.versionOlder mostOfVersion "1.3.3"
      then "https://developer.download.nvidia.com/compute/cutensor/${mostOfVersion}/local_installers/libcutensor-${platform}-${version}.tar.gz"
      else "https://developer.download.nvidia.com/compute/cutensor/redist/libcutensor/${platform}/libcutensor-${platform}-${version}-archive.tar.xz";
    inherit hash;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoPatchelfHook
    addOpenGLRunpath
    cuda_nvcc
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    cuda_cudart
    libcublas
  ];

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  installPhase = ''
    mkdir -p "$out" "$dev"

    if [[ ! -d "${libPath}" ]] ; then
      echo "Cutensor: ${libPath} does not exist, only found:" >&2
      find "$(dirname ${libPath})"/ -maxdepth 1 >&2
      echo "This cutensor release might not support your cudatoolkit version" >&2
      exit 1
    fi

    mv include "$dev"
    mv ${libPath} "$out/lib"

    function finalRPathFixups {
      for lib in $out/lib/lib*.so; do
        addOpenGLRunpath $lib
      done
    }
    postFixupHooks+=(finalRPathFixups)
  '';

  passthru = {
    cudatoolkit = lib.warn "cutensor.passthru: cudaPackages.cudatoolkit is deprecated" cudatoolkit;
    majorVersion = lib.versions.major version;
  };

  meta = with lib; {
    description = "cuTENSOR: A High-Performance CUDA Library For Tensor Primitives";
    homepage = "https://developer.nvidia.com/cutensor";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable // {
      shortName = "cuTENSOR EULA";
      name = "cuTENSOR SUPPLEMENT TO SOFTWARE LICENSE AGREEMENT FOR NVIDIA SOFTWARE DEVELOPMENT KITS";
      url = "https://docs.nvidia.com/cuda/cutensor/license.html";
    };
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ obsidian-systems-maintenance ];
  };
}
