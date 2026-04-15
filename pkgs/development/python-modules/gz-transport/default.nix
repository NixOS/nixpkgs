{
  lib,
  stdenv,
  toPythonModule,
  python,
  pkgs,
  gz-msgs,
}:

let
  gz-transport = pkgs.gz-transport.override { python3Packages = python.pkgs; };
in
toPythonModule (
  stdenv.mkDerivation {
    pname = "gz-transport";
    inherit (gz-transport) version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    propagatedBuildInputs = [ gz-msgs ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/${python.sitePackages}"
      cp -r ${gz-transport}/lib/python/. "$out/${python.sitePackages}/"
      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ python ];
    installCheckPhase = ''
      runHook preInstallCheck
      PYTHONPATH="$out/${python.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}" \
        ${python.pythonOnBuildForHost.interpreter} -c "import gz.transport"
      runHook postInstallCheck
    '';

    meta = gz-transport.meta // {
      description = "Python bindings for gz-transport";
    };
  }
)
