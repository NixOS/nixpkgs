{
  buildPythonPackage,
  python,
  pkgs,
  gz-msgs,
}:

let
  gz-transport = pkgs.gz-transport.override { python3Packages = python.pkgs; };
in
buildPythonPackage {
  pname = "gz-transport";
  inherit (gz-transport) version;
  pyproject = false;

  # The bindings are built by the C++ package; this just places them in
  # site-packages for the selected interpreter.
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/${python.sitePackages}"
    cp -r ${gz-transport}/lib/python/. "$out/${python.sitePackages}/"
    runHook postInstall
  '';

  dependencies = [
    gz-msgs
  ];

  pythonImportsCheck = [
    "gz.transport"
  ];

  meta = gz-transport.meta // {
    description = "Python bindings for gz-transport";
  };
}
