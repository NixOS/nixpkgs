{ config, stdenv
, fetchurl
, patchelf
, cudaSupport ? config.cudaSupport or false, symlinkJoin, cudatoolkit, cudnn, nvidia_x11
}:
with stdenv.lib;
let
  tfType = if cudaSupport then "gpu" else "cpu";
  system =
    if stdenv.isx86_64
    then if      stdenv.isLinux  then "linux-x86_64"
         else if stdenv.isDarwin then "darwin-x86_64" else unavailable
    else unavailable;
  unavailable = throw "libtensorflow is not available for this platform!";
  cudatoolkit_joined = symlinkJoin {
    name = "unsplit_cudatoolkit";
    paths = [ cudatoolkit.out
              cudatoolkit.lib ];};
  rpath = makeLibraryPath ([stdenv.cc.libc stdenv.cc.cc.lib] ++
            optionals cudaSupport [ cudatoolkit_joined cudnn nvidia_x11 ]);
  patchLibs =
    if stdenv.isDarwin
    then ''
      install_name_tool -id $out/lib/libtensorflow.so $out/lib/libtensorflow.so
      install_name_tool -id $out/lib/libtensorflow_framework.so $out/lib/libtensorflow_framework.so
    ''
    else ''
      ${patchelf}/bin/patchelf --set-rpath "${rpath}:$out/lib" $out/lib/libtensorflow.so
      ${patchelf}/bin/patchelf --set-rpath "${rpath}" $out/lib/libtensorflow_framework.so
    '';

in stdenv.mkDerivation rec {
  pname = "libtensorflow";
  version = "1.9.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://storage.googleapis.com/tensorflow/${pname}/${pname}-${tfType}-${system}-${version}.tar.gz";
    sha256 =
      if system == "linux-x86_64" then
        if cudaSupport
        then "1q3mh06x344im25z7r3vgrfksfdsi8fh8ldn6y2mf86h4d11yxc3"
        else "0l9ps115ng5ffzdwphlqmj3jhidps2v5afppdzrbpzmy41xz0z21"
      else if system == "darwin-x86_64" then
        if cudaSupport
        then unavailable
        else "1qj0v1706w6mczycdsh38h2glyv5d25v62kdn98wxd5rw8f9v657"
      else unavailable;
  };

  # Patch library to use our libc, libstdc++ and others
  buildCommand = ''
    . $stdenv/setup
    mkdir -pv $out
    tar -C $out -xzf $src
    chmod +w $out/lib/libtensorflow.so
    chmod +w $out/lib/libtensorflow_framework.so
    ${patchLibs}
    chmod -w $out/lib/libtensorflow.so
    chmod -w $out/lib/libtensorflow_framework.so

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
    homepage = https://www.tensorflow.org/versions/master/install/install_c;
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin;
    maintainers = [maintainers.basvandijk];
  };
}
