{ callPackage
, stdenv
, fetchzip
, lib
, libcxx

, addOpenGLRunpath
, patchelf
, fixDarwinDylibNames

, cudaSupport
}:

let
  # The binary libtorch distribution statically links the CUDA
  # toolkit. This means that we do not need to provide CUDA to
  # this derivation. However, we should ensure on version bumps
  # that the CUDA toolkit for `passthru.tests` is still
  # up-to-date.
  version = "2.0.0";
  device = if cudaSupport then "cuda" else "cpu";
  srcs = import ./binary-hashes.nix version;
  unavailable = throw "libtorch is not available for this platform";
  libcxx-for-libtorch = if stdenv.hostPlatform.system == "x86_64-darwin" then libcxx else stdenv.cc.cc.lib;
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
    for f in $out/lib/*.dylib; do
        otool -L $f
    done
    for f in $out/lib/*.dylib; do
      install_name_tool -id $out/lib/$(basename $f) $f || true
      for rpath in $(otool -L $f | grep rpath | awk '{print $1}');do
        install_name_tool -change $rpath $out/lib/$(basename $rpath) $f
      done
      if otool -L $f | grep /usr/lib/libc++ >& /dev/null; then
        install_name_tool -change /usr/lib/libc++.1.dylib ${libcxx-for-libtorch.outPath}/lib/libc++.1.0.dylib $f
      fi
    done
    for f in $out/lib/*.dylib; do
        otool -L $f
    done
  '';

  outputs = [ "out" "dev" ];

  passthru.tests.cmake = callPackage ./test {
    inherit cudaSupport;
  };

  meta = with lib; {
    description = "C++ API of the PyTorch machine learning framework";
    homepage = "https://pytorch.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = licenses.bsd3;
    maintainers = with maintainers; [ junjihashimoto ];
    platforms = platforms.unix;
  };
}
