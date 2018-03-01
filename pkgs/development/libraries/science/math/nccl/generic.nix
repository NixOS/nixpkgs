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
  name = "cudatoolkit-${cudatoolkit.majorVersion}-nccl-${version}";

  inherit version;

  src = requireFile rec {
    name = srcName;
    inherit sha256;
    message = ''
      This nix expression requires that ${name} is already part of the store.
      Register yourself to NVIDIA Accelerated Computing Developer Program, retrieve the NCCL library
      at https://developer.nvidia.com/nccl, and run the following command in the download directory:
      nix-prefetch-url file://${name}
    '';
  };

  unpackCmd = "tar xJf $src";

  installPhase = ''
    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "$p:${lib.makeLibraryPath [ stdenv.cc.cc ]}" $1
    }
    fixRunPath lib/libnccl.so

    mkdir -p $out
    cp -a include $out/include
    cp -a lib $out/lib
  '';

  propagatedBuildInputs = [
    cudatoolkit
  ];

  passthru = {
    inherit cudatoolkit;
  };

  meta = with stdenv.lib; {
    description = "Multi-GPU and multi-node collective communication primitives that are performance optimized for NVIDIA GPUs";
    homepage = https://developer.nvidia.com/nccl;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter ];
  };
}
