{ stdenv
, requireFile
, cudatoolkit
}:

stdenv.mkDerivation rec {
  version = "5.0";
  cudatoolkit_version = "7.5";

  name = "cudatoolkit-${cudatoolkit_version}-cudnn-${version}";

  src = requireFile rec {
    name = "cudnn-${cudatoolkit_version}-linux-x64-v${version}-ga.tgz";
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Register yourself to NVIDIA Accelerated Computing Developer Program, retrieve the cuDNN library
      at https://developer.nvidia.com/cudnn, and run the following command in the download directory:
      nix-prefetch-url file://${name}
    '';
    sha256 = "c4739a00608c3b66a004a74fc8e721848f9112c5cb15f730c1be4964b3a23b3a";
  };

  phases = "unpackPhase installPhase fixupPhase";

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

  meta = {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = stdenv.lib.licenses.unfree;
  };
}
