{
  buildPythonPackage,
  python,
  pkgs,
  gz-math,
  gz-msgs,
  gz-transport,
  sdformat,
}:

let
  gz-sim = pkgs.gz-sim.override { python3Packages = python.pkgs; };
in
buildPythonPackage {
  pname = "gz-sim";
  inherit (gz-sim) version;
  pyproject = false;

  # The bindings are built by the C++ package; this just places them in
  # site-packages for the selected interpreter.
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/${python.sitePackages}"
    cp -r ${gz-sim}/lib/python/. "$out/${python.sitePackages}/"
    runHook postInstall
  '';

  dependencies = [
    gz-math
    gz-msgs
    gz-transport
    sdformat
  ];

  pythonImportsCheck = [
    "gz.sim"
    "gz.common"
  ];

  meta = gz-sim.meta // {
    description = "Python bindings for gz-sim";
  };
}
