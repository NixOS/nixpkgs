{
  lib,
  stdenv,
  buildPythonPackage,
  finufft,
  python,

  # dependencies
  numpy,
  packaging,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "finufft";
  inherit (finufft) version src;
  format = "other";
  dontBuild = true;
  __structuredAttrs = true;

  dependencies = [
    numpy
    packaging
  ];

  # The Python bindings are pure Python + ctypes, no build system.
  # Install the package files and symlink libfinufft into the package directory so
  # np.ctypeslib.load_library finds it at runtime.
  installPhase =
    let
      libFilename = "libfinufft${stdenv.hostPlatform.extensions.sharedLibrary}";
    in
    ''
      runHook preInstall

      libdir=$out/${python.sitePackages}/finufft
      mkdir -p "$libdir"
      cp python/finufft/finufft/*.py "$libdir"/
      ln -s ${lib.getLib finufft}/lib/${libFilename} "$libdir"/${libFilename}

      runHook postInstall
    '';

  pythonImportsCheck = [ "finufft" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    cd python/finufft/test
  '';

  meta = finufft.meta // {
    description = "Python interface to FINUFFT";
  };
})
