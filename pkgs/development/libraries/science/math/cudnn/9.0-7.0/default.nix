{ stdenv
, lib
, requireFile
, cudatoolkit
, fetchurl
}:

stdenv.mkDerivation rec {
  version = "7.0";
  cudatoolkit_version = "9.0";

  name = "cudatoolkit-${cudatoolkit_version}-cudnn-${version}";

  src = requireFile rec {
    name = "cudnn-${cudatoolkit_version}-linux-x64-v7.tgz";
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Register yourself to NVIDIA Accelerated Computing Developer Program, retrieve the cuDNN library
      at https://developer.nvidia.com/cudnn, and run the following command in the download directory:
      nix-prefetch-url file://${name}
    '';
    sha256 = "1ld5x819vya6p2ppmr7i3lz9ac2y81kssgbzgd0lsign7r2qjapc";
  };

  installPhase = ''
    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "$p:${lib.makeLibraryPath [ stdenv.cc.cc ]}" $1
    }
    fixRunPath lib64/libcudnn.so

    mkdir -p $out
    cp -a include $out/include
    cp -a lib64 $out/lib64
  '';

  propagatedBuildInputs = [
    cudatoolkit
  ];

  meta = with stdenv.lib; {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter ];
  };
}
