{ stdenv
, lib
, libPath
, cudatoolkit
, fetchurl
, autoPatchelfHook
, addOpenGLRunpath

, version
, hash
}:

let
  mostOfVersion = builtins.concatStringsSep "."
    (lib.take 3 (lib.versions.splitVersion version));
in

stdenv.mkDerivation {
  pname = "cudatoolkit-${cudatoolkit.majorVersion}-cutensor";
  inherit version;

  src = fetchurl {
    url = "https://developer.download.nvidia.com/compute/cutensor/${mostOfVersion}/local_installers/libcutensor-${stdenv.hostPlatform.parsed.kernel.name}-${stdenv.hostPlatform.parsed.cpu.name}-${version}.tar.gz";
    inherit hash;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoPatchelfHook
    addOpenGLRunpath
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  propagatedBuildInputs = [
    cudatoolkit
  ];

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  installPhase = ''
    mkdir -p "$out" "$dev"
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
    inherit cudatoolkit;
    majorVersion = lib.versions.major version;
  };

  meta = with lib; {
    description = "cuTENSOR: A High-Performance CUDA Library For Tensor Primitives";
    homepage = "https://developer.nvidia.com/cutensor";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ obsidian-systems-maintenance ];
  };
}
