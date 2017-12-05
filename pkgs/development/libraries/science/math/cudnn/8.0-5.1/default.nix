{ stdenv
, requireFile
, cudatoolkit
, fetchurl
}:

stdenv.mkDerivation rec {
  version = "5.1";
  cudatoolkit_version = "8.0";

  name = "cudatoolkit-${cudatoolkit_version}-cudnn-${version}";

  src = fetchurl {
    url = "http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/cudnn-8.0-linux-x64-v5.1.tgz";
    sha256 = "1kj50smlkm347wfbfqvy09ylvad1zapqjc9yqvfykmiddyrij1y1";
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
