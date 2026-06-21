{
  lib,
  stdenv,
  toPythonModule,
  python,
  pkgs,
}:

let
  gz-math = pkgs.gz-math.override { python3Packages = python.pkgs; };
in
toPythonModule (
  stdenv.mkDerivation {
    pname = "gz-math";
    inherit (gz-math) version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/${python.sitePackages}"
      cp -r ${gz-math}/lib/python/. "$out/${python.sitePackages}/"
      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ python ];
    installCheckPhase = ''
      runHook preInstallCheck
      PYTHONPATH="$out/${python.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}" \
        ${python.pythonOnBuildForHost.interpreter} -c "import gz.math"
      runHook postInstallCheck
    '';

    meta = gz-math.meta // {
      description = "Python bindings for gz-math";
    };
  }
)
