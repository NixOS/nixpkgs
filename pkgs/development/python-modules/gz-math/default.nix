{
  buildPythonPackage,
  python,
  pkgs,
}:

let
  gz-math = pkgs.gz-math.override { python3Packages = python.pkgs; };
in
buildPythonPackage {
  pname = "gz-math";
  inherit (gz-math) version;
  pyproject = false;

  # The bindings are built by the C++ package; this just places them in
  # site-packages for the selected interpreter.
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/${python.sitePackages}"
    cp -r ${gz-math}/lib/python/. "$out/${python.sitePackages}/"
    runHook postInstall
  '';

  dependencies = [ ];

  pythonImportsCheck = [
    "gz.math"
  ];

  meta = gz-math.meta // {
    description = "Python bindings for gz-math";
  };
}
