{ lib, stdenv
, fetchurl
, addOpenGLRunpath
, cudaSupport ? false, cudaPackages ? {}
, symlinkJoin
}:

with lib;
let
  broken = !stdenv.isLinux && !stdenv.isDarwin;

  inherit (cudaPackages) cudatoolkit cudnn;

  tfType = if cudaSupport then "gpu" else "cpu";

  system =
    if stdenv.isLinux then "linux"
    else "darwin";

  platform =  "x86_64";

  rpath = makeLibraryPath ([stdenv.cc.libc stdenv.cc.cc.lib]
                           ++ optionals cudaSupport [ cudatoolkit.out cudatoolkit.lib cudnn ]);

  packages = import ./binary-hashes.nix;

  patchLibs =
    if stdenv.isDarwin
    then ''
      install_name_tool -id $out/lib/libtensorflow.dylib $out/lib/libtensorflow.dylib
      install_name_tool -id $out/lib/libtensorflow_framework.dylib $out/lib/libtensorflow_framework.dylib
    ''
    else ''
      patchelf --set-rpath "${rpath}:$out/lib" $out/lib/libtensorflow.so
      patchelf --set-rpath "${rpath}" $out/lib/libtensorflow_framework.so
      ${optionalString cudaSupport ''
        addOpenGLRunpath $out/lib/libtensorflow.so $out/lib/libtensorflow_framework.so
      ''}
    '';

in stdenv.mkDerivation rec {
  pname = "libtensorflow";
  inherit (packages) version;

  src = fetchurl packages."${tfType}-${system}-${platform}";

  nativeBuildInputs = optional cudaSupport addOpenGLRunpath;

  # Patch library to use our libc, libstdc++ and others
  buildCommand = ''
    mkdir -pv $out
    tar -C $out -xzf $src
    chmod -R +w $out
    ${patchLibs}

    # Write pkg-config file.
    mkdir $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/tensorflow.pc << EOF
    Name: TensorFlow
    Version: ${version}
    Description: Library for computation using data flow graphs for scalable machine learning
    Requires:
    Libs: -L$out/lib -ltensorflow
    Cflags: -I$out/include/tensorflow
    EOF
  '';

  meta = {
    description = "C API for TensorFlow";
    homepage = "https://www.tensorflow.org/install/lang_c";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
