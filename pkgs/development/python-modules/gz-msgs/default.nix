{
  lib,
  stdenv,
  toPythonModule,
  python,
  pkgs,
  protobuf,
}:

let
  gz-msgs = pkgs.gz-msgs.override { python3Packages = python.pkgs; };
in
toPythonModule (
  stdenv.mkDerivation {
    pname = "gz-msgs";
    inherit (gz-msgs) version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    propagatedBuildInputs = [ protobuf ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/${python.sitePackages}"
      cp -r ${gz-msgs}/lib/python/. "$out/${python.sitePackages}/"
      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ python ];
    installCheckPhase = ''
      runHook preInstallCheck
      PYTHONPATH="$out/${python.sitePackages}:${protobuf}/${python.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}" \
        ${python.pythonOnBuildForHost.interpreter} -c "import gz.msgs.vector3d_pb2"
      runHook postInstallCheck
    '';

    meta = gz-msgs.meta // {
      description = "Python bindings for gz-msgs";
    };
  }
)
