{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rosdep,
  pyyaml,
  setuptools,
  catkin-pkg,
  rospkg,
  rosdistro,
  pytestCheckHook,
  nix-update-script,
  testers,
}:

buildPythonPackage rec {
  pname = "rosdep";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "rosdep";
    tag = version;
    hash = "sha256-gubZKdB6OGECOJTR5HH3rX9D7egbvNchYgLcGcfh7tg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    catkin-pkg
    rospkg
    rosdistro
  ];

  checkInputs = [ pytestCheckHook ];

  doCheck = false; # Disabled until I can get distutils to be found in checkPhase

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      helpTest = testers.runCommand {
        name = "rosdep";
        script = ''
          rosdep --help
          touch $out
        '';
        nativeBuildInputs = [ rosdep ];
      };
      versionTest = testers.testVersion {
        package = rosdep;
        command = "rosdep --version";
        version = version;
      };
    };
  };

  meta = {
    description = "Package manager abstraction tool for ROS";
    homepage = "https://wiki.ros.org/rosdep";
    mainProgram = "rosdep";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
  };
}
