{
  buildPythonPackage,
  hatchling,
  lib,
  ruff,
}:

buildPythonPackage {
  inherit (ruff)
    pname
    version
    src
    meta
    ;
  pyproject = true;

  build-system = [ hatchling ];

  postPatch =
    # Do not rely on path lookup at runtime to find the ruff binary.
    # Use the propagated binary instead.
    ''
      substituteInPlace python/ruff/__main__.py \
        --replace-fail \
          'ruff_exe = "ruff" + sysconfig.get_config_var("EXE")' \
          'return "${lib.getExe ruff}"'
    ''
    # Sidestep the maturin build system in favour of reusing the binary already built by nixpkgs,
    # to avoid rebuilding the ruff binary for every active python package set.
    + ''
      substituteInPlace pyproject.toml \
        --replace-fail 'requires = ["maturin>=1.9,<2.0"]' 'requires = ["hatchling"]' \
        --replace-fail 'build-backend = "maturin"' 'build-backend = "hatchling.build"'

      cat >> pyproject.toml <<EOF
      [tool.hatch.build]
      packages = ['python/ruff']

      EOF
    '';

  postInstall = ''
    mkdir -p $out/bin && ln -s ${lib.getExe ruff} $out/bin/ruff
  '';

  pythonImportsCheck = [ "ruff" ];
}
