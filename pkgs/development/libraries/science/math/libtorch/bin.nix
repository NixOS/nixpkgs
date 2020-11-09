{ callPackage
, stdenv
, fetchzip
, lib

, addOpenGLRunpath
, patchelf
, fixDarwinDylibNames

, cudaSupport
, nvidia_x11
}:

let
  version = "1.7.0";
  device = if cudaSupport then "cuda" else "cpu";
  srcs = import ./binary-hashes.nix version;
  unavailable = throw "libtorch is not available for this platform";
in stdenv.mkDerivation {
  inherit version;
  pname = "libtorch";

  src = fetchzip srcs."${stdenv.targetPlatform.system}-${device}" or unavailable;

  nativeBuildInputs =
    if stdenv.isDarwin then [ fixDarwinDylibNames ]
    else [ addOpenGLRunpath patchelf ]
      ++ stdenv.lib.optionals cudaSupport [ addOpenGLRunpath ];

  buildInputs = [
    stdenv.cc.cc
  ] ++ lib.optionals cudaSupport [ nvidia_x11 ];

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;

  installPhase = ''
    # Copy headers and CMake files.
    install -Dm755 -t $dev/lib lib/*.a
    cp -r include $dev
    cp -r share $dev

    install -Dm755 -t $out/lib lib/*${stdenv.hostPlatform.extensions.sharedLibrary}*

    # We do not care about Java support...
    rm -f $out/lib/lib*jni* 2> /dev/null || true
  '';

  postFixup = let
    libPaths = [ stdenv.cc.cc.lib ]
      ++ stdenv.lib.optionals cudaSupport [ nvidia_x11 ];
    rpath = stdenv.lib.makeLibraryPath libPaths;
  in stdenv.lib.optionalString stdenv.isLinux ''
    find $out/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting rpath for $lib..."
      patchelf --set-rpath "${rpath}:$out/lib" "$lib"
      ${lib.optionalString cudaSupport ''
        addOpenGLRunpath "$lib"
      ''}
    done
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
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

  passthru.tests.cmake = callPackage ./test { };

  meta = with stdenv.lib; {
    description = "C++ API of the PyTorch machine learning framework";
    homepage = "https://pytorch.org/";
    license = licenses.unfree; # Includes CUDA and Intel MKL.
    platforms = with platforms; linux ++ darwin;
  };
}
