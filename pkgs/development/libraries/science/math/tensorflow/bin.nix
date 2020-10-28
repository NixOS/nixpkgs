{ stdenv
, fetchurl
, addOpenGLRunpath
, cudaSupport ? false, symlinkJoin, cudatoolkit, cudnn, nvidia_x11
}:

with stdenv.lib;
let
  unavailable = throw "libtensorflow is not available for this platform!";

  tfType = if cudaSupport then "gpu" else "cpu";

  system =
    if      stdenv.isLinux  then "linux"
    else if stdenv.isDarwin then "darwin"
    else unavailable;

  platform =
    if stdenv.isx86_64 then "x86_64"
    else unavailable;

  rpath = makeLibraryPath ([stdenv.cc.libc stdenv.cc.cc.lib] ++
            optionals cudaSupport [ cudatoolkit.out cudatoolkit.lib cudnn nvidia_x11 ]);

  packages = import ./binary-hashes.nix;
  packageName = "${tfType}-${system}-${platform}";
  url = packages.${packageName} or unavailable;

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

  src = fetchurl url;

  nativeBuildInputs = optional cudaSupport addOpenGLRunpath;

  # Patch library to use our libc, libstdc++ and others
  buildCommand = ''
    mkdir -pv $out
    tar -C $out -xzf $src
    chmod -R +w $out
    ${patchLibs}

    # Write pkgconfig file.
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
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ basvandijk ];
  };
}
