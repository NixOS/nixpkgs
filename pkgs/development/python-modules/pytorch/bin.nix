{ lib, stdenv
, buildPythonPackage
, fetchurl
, isPy37
, isPy38
, isPy39
, python
, addOpenGLRunpath
, future
, numpy
, patchelf
, pyyaml
, requests
, setuptools
, typing-extensions
}:

let
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  srcs = import ./binary-hashes.nix version;
  unsupported = throw "Unsupported system";
  version = "1.10.0";
in buildPythonPackage {
  inherit version;

  pname = "pytorch";
  # Don't forget to update pytorch to the same version.

  format = "wheel";

  disabled = !(isPy37 || isPy38 || isPy39);

  src = fetchurl srcs."${stdenv.system}-${pyVerNoDot}" or unsupported;

  nativeBuildInputs = [
    addOpenGLRunpath
    patchelf
  ];

  propagatedBuildInputs = [
    future
    numpy
    pyyaml
    requests
    setuptools
    typing-extensions
  ];

  postInstall = ''
    # ONNX conversion
    rm -rf $out/bin
  '';

  postFixup = let
    rpath = lib.makeLibraryPath [ stdenv.cc.cc.lib ];
  in ''
    find $out/${python.sitePackages}/torch/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting rpath for $lib..."
      patchelf --set-rpath "${rpath}:$out/${python.sitePackages}/torch/lib" "$lib"
      addOpenGLRunpath "$lib"
    done
  '';

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torch" ];

  meta = with lib; {
    description = "Open source, prototype-to-production deep learning platform";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${version}";
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
