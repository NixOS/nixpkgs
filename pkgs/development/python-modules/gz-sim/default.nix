{
  lib,
  stdenv,
  toPythonModule,
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
toPythonModule (
  stdenv.mkDerivation {
    pname = "gz-sim";
    inherit (gz-sim) version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    propagatedBuildInputs = [
      gz-math
      gz-msgs
      gz-transport
      sdformat
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/${python.sitePackages}"
      cp -r ${gz-sim}/lib/python/. "$out/${python.sitePackages}/"
      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ python ];
    installCheckPhase = ''
      runHook preInstallCheck
      PYTHONPATH="$out/${python.sitePackages}:${gz-math}/${python.sitePackages}:${sdformat}/${python.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}" \
        ${python.pythonOnBuildForHost.interpreter} -c "import gz.sim; import gz.common"
      runHook postInstallCheck
    '';

    meta = gz-sim.meta // {
      description = "Python bindings for gz-sim";
    };
  }
)
