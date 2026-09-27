{
  lib,
  buildFHSEnv,
  ufbt-unwrapped,
  libz,

  extraRuntimeDependencies ? [ ],
}:
# Wrap ufbt in an FHS wrapper as it dynamically downloads and executes toolchains
buildFHSEnv {
  pname = "ufbt";
  inherit (ufbt-unwrapped) version;

  targetPkgs =
    pkgs:
    [
      ufbt-unwrapped
      libz
    ]
    ++ extraRuntimeDependencies;

  runScript = "ufbt";

  extraInstallCommands = ''
    ln -s ${ufbt-unwrapped}/bin/ufbt-bootstrap $out/bin/ufbt-bootstrap
  '';

  meta = {
    inherit (ufbt-unwrapped.meta)
      description
      homepage
      changelog
      license
      mainProgram
      maintainers
      ;
  };
}
