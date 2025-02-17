{
  buildPythonPackage,
  ruff,
  rustPlatform,
  installShellFiles,
}:

buildPythonPackage {
  inherit (ruff)
    pname
    version
    src
    cargoDeps
    postInstall
    meta
    ;

  # Do not rely on path lookup at runtime to find the ruff binary
  postPatch = ''
    substituteInPlace python/ruff/__main__.py \
      --replace-fail \
        'ruff_exe = "ruff" + sysconfig.get_config_var("EXE")' \
        'return "${placeholder "out"}/bin/ruff"'
  '';

  pyproject = true;

  nativeBuildInputs = [
    installShellFiles
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "ruff" ];
}
