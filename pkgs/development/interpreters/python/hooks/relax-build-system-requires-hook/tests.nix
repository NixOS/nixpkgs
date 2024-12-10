{ pythonOnBuildForHost, runCommand }:
let
  # pyproject.toml which has unnecessary version constraints in build-system.requires
  pyprojectToml = runCommand "pyproject_toml" { } ''
    mkdir $out
    cat <<EOF > $out/pyproject.toml
    [project]
    name = "relax-build-system-requires-hook-test"
    version = "1.0.0"
    [build-system]
    requires = ["setuptools==0.0.0", 'dummy[foo]>=2,<3; python_version>"2.0"']
    EOF
  '';

  setupPy = runCommand "setup_py" { } ''
    mkdir $out
    cat <<EOF > $out/setup.py
    from setuptools import setup

    setup(
      setup_requires = [ "setuptools==0.0.0", 'dummy[foo]>=2,<3; python_version>"2.0"' ],
      name = "relax-build-system-requires-hook-test",
      version = "1.0.0",
      tests_require = [ "deprecated_arg" ],
    )
    EOF
  '';

  setupPyWithRequirementsFile = runCommand "setup_py-with-requirements-file" { } ''
    mkdir $out
    cat <<EOF > $out/setup_requirements.txt
    setuptools==0.0.0
    dummy[foo]>=2,<3; python_version>"2.0"
    EOF

    cat <<EOF > $out/setup.py
    import pathlib

    from setuptools import setup

    setup_requires = pathlib.Path("setup_requirements.txt").read_text()

    setup(
      setup_requires = setup_requires,
      name = "relax-build-system-requires-hook-test",
      version = "1.0.0",
    )
    EOF
  '';

  setupCfg = runCommand "setup_cfg" { } ''
    mkdir $out
    cat <<EOF > $out/setup.py
    from setuptools import setup

    setup()
    EOF

    cat <<EOF > $out/setup.cfg
    [metadata]
    name = relax-build-system-requires-hook-test
    version = 1.0.0

    [options]
    setup_requires =
      setuptools==0.0.0
      dummy[foo]>=2,<3; python_version>"2.0"
    tests_require =
      deprecated_arg
    EOF
  '';

  # the source of the example project
  projectSource =
    config:
    runCommand "my-project-source" { } ''
      mkdir -p $out/src
      install ${config}/* -t $out
      touch $out/src/__init__.py
    '';
in
{
  pyproject = pythonOnBuildForHost.pkgs.buildPythonPackage {
    pname = "relax-build-system-requires-hook-pyproject-test";
    version = "1.0.0";
    pyproject = true;

    src = projectSource pyprojectToml;

    build-system = [ pythonOnBuildForHost.pkgs.setuptools ];
    relaxBuildSystem = [ "setuptools" ];
    removeBuildSystem = [ "dummy" ];
  };

  setuppy = pythonOnBuildForHost.pkgs.buildPythonPackage {
    # list[str] is expected as setup_requires
    pname = "relax-build-system-requires-hook-setuppy-test";
    version = "1.0.0";
    pyproject = true;

    src = projectSource setupPy;

    build-system = [ pythonOnBuildForHost.pkgs.setuptools ];
    relaxBuildSystem = [ "setuptools" ];
    removeBuildSystem = [ "dummy" ];
    removeTestsRequire = true;
  };

  setuppyWithRequirementsFile = pythonOnBuildForHost.pkgs.buildPythonPackage {
    # str is expected as setup_requires
    pname = "relax-build-system-requires-hook-setuppy-with-requirements-file-test";
    version = "1.0.0";
    pyproject = true;

    src = projectSource setupPyWithRequirementsFile;

    build-system = [ pythonOnBuildForHost.pkgs.setuptools ];
    relaxBuildSystem = [ "setuptools" ];
    removeBuildSystem = [ "dummy" ];
  };

  setupcfg = pythonOnBuildForHost.pkgs.buildPythonPackage {
    pname = "relax-build-system-requires-hook-setupcfg-test";
    version = "1.0.0";
    pyproject = true;

    src = projectSource setupCfg;

    build-system = [ pythonOnBuildForHost.pkgs.setuptools ];
    relaxBuildSystem = [ "setuptools" ];
    removeBuildSystem = [ "dummy" ];
    removeTestsRequire = true;
  };
}
