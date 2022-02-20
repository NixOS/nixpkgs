{ version
, srcName
, hash ? null
, sha256 ? null
}:

assert (hash != null) || (sha256 != null);

{ stdenv
, lib
, cudatoolkit
, fetchurl
, addOpenGLRunpath
, # The distributed version of CUDNN includes both dynamically liked .so files,
  # as well as statically linked .a files.  However, CUDNN is quite large
  # (multiple gigabytes), so you can save some space in your nix store by
  # removing the statically linked libraries if you are not using them.
  #
  # Setting this to true removes the statically linked .a files.
  # Setting this to false keeps these statically linked .a files.
  removeStatic ? false
}:

stdenv.mkDerivation {
  name = "cudatoolkit-${cudatoolkit.majorVersion}-cudnn-${version}";

  inherit version;

  src = let
    hash_ = if hash != null then { inherit hash; } else { inherit sha256; };
  in fetchurl ({
    # URL from NVIDIA docker containers: https://gitlab.com/nvidia/cuda/blob/centos7/7.0/runtime/cudnn4/Dockerfile
    url = "https://developer.download.nvidia.com/compute/redist/cudnn/v${version}/${srcName}";
  } // hash_);

  nativeBuildInputs = [ addOpenGLRunpath ];

  # Some cuDNN libraries depend on things in cudatoolkit, eg.
  # libcudnn_ops_infer.so.8 tries to load libcublas.so.11. So we need to patch
  # cudatoolkit into RPATH. See also https://github.com/NixOS/nixpkgs/blob/88a2ad974692a5c3638fcdc2c772e5770f3f7b21/pkgs/development/python-modules/jaxlib/bin.nix#L78-L98.
  installPhase = ''
    runHook preInstall

    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "''${p:+$p:}${lib.makeLibraryPath [ stdenv.cc.cc cudatoolkit.lib ]}:${cudatoolkit}/lib:\$ORIGIN/" $1
    }

    for lib in lib64/lib*.so; do
      fixRunPath $lib
    done

    mkdir -p $out
    cp -a include $out/include
    cp -a lib64 $out/lib64
  '' + lib.optionalString removeStatic ''
    rm -f $out/lib64/*.a
  '' + ''
    runHook postInstall
  '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = ''
    for lib in $out/lib/lib*.so; do
      addOpenGLRunpath $lib
    done
  '';

  propagatedBuildInputs = [
    cudatoolkit
  ];

  passthru = {
    inherit cudatoolkit;
    majorVersion = lib.versions.major version;
  };

  meta = with lib; {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter ];
  };
}
