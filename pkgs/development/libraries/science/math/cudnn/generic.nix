{ stdenv
, lib
, zlib
, useCudatoolkitRunfile ? false
, cudaVersion
, cudaMajorVersion
, cudatoolkit # if cuda>=11: only used for .cc
, libcublas ? null # cuda <11 doesn't ship redist packages
, autoPatchelfHook
, autoAddOpenGLRunpathHook
, fetchurl
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
, hash ? ""
, sha256 ? ""
, supportedCudaVersions ? [ ]
}:

assert (hash != "") || (sha256 != "");

assert useCudatoolkitRunfile || (libcublas != null);

let
  inherit (cudatoolkit) cc;

  majorMinorPatch = version: lib.concatStringsSep "." (lib.take 3 (lib.splitVersion version));
  version = majorMinorPatch fullVersion;

  cudatoolkit_root =
    if useCudatoolkitRunfile
    then cudatoolkit
    else libcublas;
in
stdenv.mkDerivation {
  pname = "cudatoolkit-${cudaMajorVersion}-cudnn";
  inherit version;

  src = fetchurl {
    inherit url hash sha256;
  };

  # Check and normalize Runpath against DT_NEEDED using autoPatchelf.
  # Prepend /run/opengl-driver/lib using addOpenGLRunpath for dlopen("libcudacuda.so")
  nativeBuildInputs = [
    autoPatchelfHook
    autoAddOpenGLRunpathHook
  ];

  # Used by autoPatchelfHook
  buildInputs = [
    cc.cc.lib # libstdc++
    zlib
    cudatoolkit_root
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

  # Without --add-needed autoPatchelf forgets $ORIGIN on cuda>=8.0.5.
  postFixup = lib.optionalString (lib.versionAtLeast fullVersion "8.0.5") ''
    patchelf $out/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
  '';

  passthru = {
    inherit useCudatoolkitRunfile;

    cudatoolkit = lib.warn ''
      cudnn.cudatoolkit passthru attribute is deprecated;
      if your derivation uses cudnn directly, it should probably consume cudaPackages instead
    ''
      cudatoolkit;

    majorVersion = lib.versions.major version;
  };

  meta = with lib; {
    # Check that the cudatoolkit version satisfies our min/max constraints (both
    # inclusive). We mark the package as broken if it fails to satisfies the
    # official version constraints (as recorded in default.nix). In some cases
    # you _may_ be able to smudge version constraints, just know that you're
    # embarking into unknown and unsupported territory when doing so.
    broken = !(elem cudaVersion supportedCudaVersions);
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # TODO: consider marking unfreRedistributable when not using runfile
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter samuela ];
  };
}
