{ stdenv
, requireFile
, cudatoolkit
}:

stdenv.mkDerivation rec {
  version = "5.0";
  cudatoolkit_version = "8.0";

  name = "cudatoolkit-${cudatoolkit_version}-cudnn-${version}";

  src = requireFile rec {
    name = "cudnn-${cudatoolkit_version}-linux-x64-v${version}-ga.tgz";
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Register yourself to NVIDIA Accelerated Computing Developer Program, retrieve the cuDNN library
      at https://developer.nvidia.com/cudnn, and run the following command in the download directory:
      nix-prefetch-url file://${name}
    '';
    sha256 = "af80eb1ce0cb51e6a734b2bdc599e6d50b676eab3921e5bddfe5443485df86b6";
  };

  installPhase = ''
    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "$p:${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}" $1
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
    homepage = https://developer.nvidia.com/cudnn;
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ mdaiter ];
  };
}
