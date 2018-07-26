{ stdenv
, fetchurl
, patchelf
, cudaSupport ? false, symlinkJoin, cudatoolkit, cudnn, nvidia_x11
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
  version = "1.8.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://storage.googleapis.com/tensorflow/${pname}/${pname}-${tfType}-${system}-${version}.tar.gz";
    sha256 =
      if system == "linux-x86_64" then
        if cudaSupport
        then "0m1g4sqr9as0jgfx7wlyay2nkad6wgvsyk2gvhfkqkq5sm1vbx85"
        else "0qzy15rc3x961cyi3bqnygrcnw4x69r28xkwhpwrv1r0gi6k73ha"
      else if system == "darwin-x86_64" then
        if cudaSupport
        then unavailable
        else "0q8lmyj8l50hl6l48c640ixanvhqf2836bicyl9p2x8sj97b7y8l"
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
  '';

  meta = {
    description = "C API for TensorFlow";
    homepage = https://www.tensorflow.org/versions/master/install/install_c;
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin;
    maintainers = [maintainers.basvandijk];
  };
}
