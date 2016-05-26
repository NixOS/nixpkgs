{ stdenv, requireFile }:

stdenv.mkDerivation rec {
  version = "4.0";

  name = "cudnn-${version}";

  src = requireFile rec {
    name = "cudnn-7.0-linux-x64-v${version}-prod.tgz";
    message = '' 
      This nix expression requires that ${name} is
      already part of the store. Register yourself to NVIDIA Accelerated Computing Developer Program
      and download cuDNN library at https://developer.nvidia.com/cudnn, and store it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    sha256 = "0zgr6qdbc29qw6sikhrh6diwwz7150rqc8a49f2qf37j2rvyyr2f";

  };

  phases = "unpackPhase installPhase fixupPhase";

  installPhase = ''
    mkdir -p $out
    cp -a include $out/include
    cp -a lib64 $out/lib64
  '';

  # all binaries are already stripped
  #dontStrip = true;

  # we did this in prefixup already
  #dontPatchELF = true;

  meta = {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = stdenv.lib.licenses.unfree;
  };
}
