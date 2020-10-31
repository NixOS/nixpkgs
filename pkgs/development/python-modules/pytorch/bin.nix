{ stdenv
, buildPythonPackage
, fetchurl
, isPy37
, isPy38
, python
, nvidia_x11
, addOpenGLRunpath
, future
, numpy
, patchelf
, pyyaml
, requests
, typing-extensions
}:

let
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  platform = if stdenv.isDarwin then "darwin" else "linux";
  srcs = import ./binary-hashes.nix version;
  unsupported = throw "Unsupported system";
  version = "1.7.0";
in buildPythonPackage {
  inherit version;

  pname = "pytorch";
  # Don't forget to update pytorch to the same version.

  format = "wheel";

  disabled = !(isPy37 || isPy38);

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
    typing-extensions
  ];

  # PyTorch are broken: the dataclasses wheel is required, but ships with
  # Python >= 3.7. Our dataclasses derivation is incompatible with >= 3.7.
  #
  # https://github.com/pytorch/pytorch/issues/46930
  #
  # Should be removed with the next PyTorch version.
  pipInstallFlags = [
    "--no-deps"
  ];

  postInstall = ''
    # ONNX conversion
    rm -rf $out/bin
  '';

  postFixup = let
    rpath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib nvidia_x11 ];
  in ''
    find $out/${python.sitePackages}/torch/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting rpath for $lib..."
      patchelf --set-rpath "${rpath}:$out/${python.sitePackages}/torch/lib" "$lib"
      addOpenGLRunpath "$lib"
    done
  '';

  pythonImportsCheck = [ "torch" ];

  meta = with stdenv.lib; {
    description = "Open source, prototype-to-production deep learning platform";
    homepage = "https://pytorch.org/";
    license = licenses.unfree; # Includes CUDA and Intel MKL.
    platforms = platforms.linux;
    maintainers = with maintainers; [ danieldk ];
  };
}
