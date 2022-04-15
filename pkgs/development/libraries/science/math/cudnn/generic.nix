{ stdenv
, lib
, zlib
, autoPatchelfHook
, cudaPackages
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

{ fullVersion
, url
, hash ? null
, sha256 ? null
, supportedCudaVersions ? [ ]
}:

assert (hash != null) || (sha256 != null);

let
  inherit (cudaPackages) cudaMajorVersion libcublas;
  inherit (cudaPackages.cudatoolkit) cc;

  majorMinorPatch = version: lib.concatStringsSep "." (lib.take 3 (lib.splitVersion version));
  version = majorMinorPatch fullVersion;
in
stdenv.mkDerivation {
  name = "cudatoolkit-${cudaMajorVersion}-cudnn-${version}";

  inherit version;
  src = fetchurl {
    inherit url hash sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook addOpenGLRunpath ];

  # Used by autoPatchelfHook
  buildInputs = builtins.map lib.getLib [
    cc.cc # libstdc++
    libcublas
    zlib
  ];

  # We used to patch Runpath here, but now we use autoPatchelfHook
  #
  # Note also that version <=8.3.0 contained a subdirectory "lib64/" but in
  # version 8.3.2 it seems to have been renamed to simply "lib/".
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a include $out/include
    [ -d "lib/" ] && cp -a lib $out/lib
    [ -d "lib64/" ] && cp -a lib64 $out/lib64
  '' + lib.optionalString removeStatic ''
    rm -f $out/lib/*.a
    rm -f $out/lib64/*.a
  '' + ''
    runHook postInstall
  '';

  # Check and normalize Runpath against DT_NEEDED using autoPatchelf.
  # Prepend /run/opengl-driver/lib using addOpenGLRunpath
  # so that libcuda (which is not part of DT_NEEDED)
  # can be found at runtime with dlopen().
  # Without --add-needed autoPatchelf forgets $ORIGIN on cuda>=8.0.5.
  dontAutoPatchelf = true;
  postFixup = lib.optionalString (lib.versionAtLeast fullVersion "8.0.5") ''
    patchelf $out/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
  '' ++ ''
    autoPatchelf $out
    addOpenGLRunpath $out/lib/lib*.so
  '';

  passthru = {
    cudatoolkit = lib.warn "cudnn.cudatoolkit passthru attribute is deprecated: use cudaPackages" cudaPackages.cudatoolkit;
    inherit cudaPackages;

    majorVersion = lib.versions.major version;
  };

  meta = with lib; {
    # Check that the cudatoolkit version satisfies our min/max constraints (both
    # inclusive). We mark the package as broken if it fails to satisfies the
    # official version constraints (as recorded in default.nix). In some cases
    # you _may_ be able to smudge version constraints, just know that you're
    # embarking into unknown and unsupported territory when doing so.
    broken = !(elem cudaPackages.cudaVersion supportedCudaVersions);
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter samuela ];
  };
}
