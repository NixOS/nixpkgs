{
  buildPythonPackage,
  python,
  pkgs,
  protobuf,
}:

let
  gz-msgs = pkgs.gz-msgs.override { python3Packages = python.pkgs; };
in
buildPythonPackage {
  pname = "gz-msgs";
  inherit (gz-msgs) version;
  pyproject = false;

  # The bindings are built by the C++ package; this just places them in
  # site-packages for the selected interpreter.
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/${python.sitePackages}"
    cp -r ${gz-msgs}/lib/python/. "$out/${python.sitePackages}/"
    runHook postInstall
  '';

  dependencies = [
    protobuf
  ];

  pythonImportsCheck = [
    "gz.msgs.vector3d_pb2"
  ];

  meta = gz-msgs.meta // {
    description = "Python bindings for gz-msgs";
  };
}
