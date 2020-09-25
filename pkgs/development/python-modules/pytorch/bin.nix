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
}:

let
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  platform = if stdenv.isDarwin then "darwin" else "linux";
  srcs = import ./binary-hashes.nix;
  unsupported = throw "Unsupported system";
in buildPythonPackage {
  pname = "pytorch";
  # Don't forget to update pytorch to the same version.
  version = "1.6.0";

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
