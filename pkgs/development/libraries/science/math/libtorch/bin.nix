{ callPackage
, stdenv
, fetchzip
, lib

, addOpenGLRunpath
, patchelf
, fixDarwinDylibNames

, cudaSupport
, cudatoolkit_11_1
, cudnn_cudatoolkit_11_1
}:

let
  # The binary libtorch distribution statically links the CUDA
  # toolkit. This means that we do not need to provide CUDA to
  # this derivation. However, we should ensure on version bumps
  # that the CUDA toolkit for `passthru.tests` is still
  # up-to-date.
  version = "1.9.0";
  device = if cudaSupport then "cuda" else "cpu";
  srcs = import ./binary-hashes.nix version;
  unavailable = throw "libtorch is not available for this platform";
in stdenv.mkDerivation {
  inherit version;
  pname = "libtorch";

  src = fetchzip srcs."${stdenv.targetPlatform.system}-${device}" or unavailable;

  nativeBuildInputs =
    if stdenv.isDarwin then [ fixDarwinDylibNames ]
    else [ patchelf ] ++ lib.optionals cudaSupport [ addOpenGLRunpath ];

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;

  installPhase = ''
    # Copy headers and CMake files.
    mkdir -p $dev
    cp -r include $dev
    cp -r share $dev

    install -Dm755 -t $out/lib lib/*${stdenv.hostPlatform.extensions.sharedLibrary}*

    # We do not care about Java support...
    rm -f $out/lib/lib*jni* 2> /dev/null || true

    # Fix up library paths for split outputs
    substituteInPlace $dev/share/cmake/Torch/TorchConfig.cmake \
      --replace \''${TORCH_INSTALL_PREFIX}/lib "$out/lib" \

    substituteInPlace \
      $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
      --replace \''${_IMPORT_PREFIX}/lib "$out/lib" \
  '';

  postFixup = let
    rpath = lib.makeLibraryPath [ stdenv.cc.cc.lib ];
  in lib.optionalString stdenv.isLinux ''
    find $out/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting rpath for $lib..."
      patchelf --set-rpath "${rpath}:$out/lib" "$lib"
      ${lib.optionalString cudaSupport ''
        addOpenGLRunpath "$lib"
      ''}
    done
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -change @rpath/libshm.dylib $out/lib/libshm.dylib $out/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libtorch_cpu.dylib $out/lib/libtorch_cpu.dylib $out/lib/libtorch_python.dylib

    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libtorch.dylib
    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libtorch.dylib
    install_name_tool -change @rpath/libtorch_cpu.dylib $out/lib/libtorch_cpu.dylib $out/lib/libtorch.dylib

    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libtorch_cpu.dylib
    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libtorch_cpu.dylib
    install_name_tool -change @rpath/libtensorpipe.dylib $out/lib/libtensorpipe.dylib $out/lib/libtorch_cpu.dylib

    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libcaffe2_observers.dylib
    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libcaffe2_observers.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libcaffe2_observers.dylib
    install_name_tool -change @rpath/libtorch_cpu.dylib $out/lib/libtorch_cpu.dylib $out/lib/libcaffe2_observers.dylib

    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libcaffe2_module_test_dynamic.dylib
    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libcaffe2_module_test_dynamic.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libcaffe2_module_test_dynamic.dylib
    install_name_tool -change @rpath/libtorch_cpu.dylib $out/lib/libtorch_cpu.dylib $out/lib/libcaffe2_module_test_dynamic.dylib

    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libcaffe2_detectron_ops.dylib
    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libcaffe2_detectron_ops.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libcaffe2_detectron_ops.dylib
    install_name_tool -change @rpath/libtorch_cpu.dylib $out/lib/libtorch_cpu.dylib $out/lib/libcaffe2_detectron_ops.dylib

    install_name_tool -change @rpath/libc10.dylib $out/lib/libc10.dylib $out/lib/libshm.dylib
    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libshm.dylib
    install_name_tool -change @rpath/libtorch.dylib $out/lib/libtorch.dylib $out/lib/libshm.dylib
    install_name_tool -change @rpath/libtorch_cpu.dylib $out/lib/libtorch_cpu.dylib $out/lib/libshm.dylib

    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libtorch_global_deps.dylib
    install_name_tool -change @rpath/libtorch_cpu.dylib $out/lib/libtorch_cpu.dylib $out/lib/libtorch_global_deps.dylib
  '';

  outputs = [ "out" "dev" ];

  passthru.tests.cmake = callPackage ./test {
    inherit cudaSupport;
    cudatoolkit = cudatoolkit_11_1;
    cudnn = cudnn_cudatoolkit_11_1;
  };

  meta = with lib; {
    description = "C++ API of the PyTorch machine learning framework";
    homepage = "https://pytorch.org/";
    license = licenses.unfree; # Includes CUDA and Intel MKL.
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux ++ darwin;
  };
}
