{ stdenv, fetchurl, patchelf }:
stdenv.mkDerivation rec {
  pname = "libtensorflow";
  version = "1.8.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://storage.googleapis.com/tensorflow/${pname}/${pname}-cpu-linux-x86_64-${version}.tar.gz";
    sha256 = "0qzy15rc3x961cyi3bqnygrcnw4x69r28xkwhpwrv1r0gi6k73ha";
  };

  # Patch library to use our libc, libstdc++ and others
  buildCommand = ''
    . $stdenv/setup
    mkdir -pv $out
    tar -C $out -xzf $src
    chmod +w $out/lib/libtensorflow.so
    chmod +w $out/lib/libtensorflow_framework.so
    ${patchelf}/bin/patchelf --set-rpath "${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib:$out/lib" $out/lib/libtensorflow.so
    ${patchelf}/bin/patchelf --set-rpath "${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/lib/libtensorflow_framework.so
    chmod -w $out/lib/libtensorflow.so
    chmod -w $out/lib/libtensorflow_framework.so
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "C API for TensorFlow";
    license = licenses.asl20;
    maintainers = [maintainers.basvandijk];
    platforms = platforms.linux;
    homepage = https://www.tensorflow.org/versions/master/install/install_c;
  };
}
