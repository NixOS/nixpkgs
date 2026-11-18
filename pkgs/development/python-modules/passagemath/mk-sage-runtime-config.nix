{
  buildPythonPackage,
  lib,
  python,
  writeText,
}:

{
  pname,
  version ? "10.8.13",
  sageConf,
  ...
}@args:

let
  moduleName = lib.replaceStrings [ "-" ] [ "_" ] pname;

  configFile = writeText "${moduleName}.py" ''
    import json

    globals().update(
        json.loads(${builtins.toJSON (builtins.toJSON sageConf)})
    )
  '';
in

buildPythonPackage (
  removeAttrs args [ "sageConf" ]
  // {
    inherit pname version;

    pyproject = false;
    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm644 ${configFile} \
        "$out/${python.sitePackages}/_sage_conf/${moduleName}.py"

      runHook postInstall
    '';
  }
)
