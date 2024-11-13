{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rosdistro,
  pyyaml,
  setuptools,
  catkin-pkg,
  rospkg,
  pytestCheckHook,
  nix-update-script,
  testers,
}:

buildPythonPackage rec {
  pname = "rosdistro";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "rosdistro";
    tag = version;
    hash = "sha256-ETsQzWsoGrThxNI/L3pWEzkhmrh+jpy/KIkojPMTkLw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    catkin-pkg
    rospkg
  ];

  checkInputs = [
    # Disabled until I can get distutils to be found in checkPhase
    # pytestCheckHook
  ];

  pythonImportCheck = [ "rosdistro" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.helpTest = testers.runCommand {
      name = "rosdistro";
      script = ''
        rosdistro_build_cache --help
        touch $out
      '';
      nativeBuildInputs = [ rosdistro ];
    };
  };

  meta = {
    description = "A tool to work with rosdistro files";
    homepage = "https://wiki.ros.org/rosdistro";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
  };
}
