{ version
, srcName
, sha256
}:

{ stdenv
, lib
, requireFile
, cudatoolkit
}:

stdenv.mkDerivation rec {
  name = "cudatoolkit-${cudatoolkit.majorVersion}-cudnn-${version}";

  inherit version;

  src = requireFile rec {
    name = srcName;
    inherit sha256;
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Register yourself to NVIDIA Accelerated Computing Developer Program, retrieve the cuDNN library
      at https://developer.nvidia.com/cudnn, and run the following command in the download directory:
      nix-prefetch-url file://\$PWD/${name}
    '';
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

  passthru = {
    inherit cudatoolkit;
    majorVersion = lib.head (lib.splitString "." version);
  };

  meta = with stdenv.lib; {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter ];
  };
}
