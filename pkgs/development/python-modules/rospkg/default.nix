{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rospkg,
  catkin-pkg,
  pyyaml,
  distro,
  pytestCheckHook,
  nix-update-script,
  testers,
}:

buildPythonPackage rec {
  pname = "rospkg";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "rospkg";
    tag = version;
    hash = "sha256-b++/sa3rRaSqyMRQeju+cr6ENJZ0m0HbCA7Ep05Kcc4=";
  };

  dependencies = [
    catkin-pkg
    pyyaml
    distro
  ];

  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    # Requires distutils
    "test_rospkg_os_detect"
  ];

  setupHook = ./setup-hook.sh;

  passthru = {
    updateScript = nix-update-script { };
    tests.helpTest = testers.runCommand {
      name = "rospkg";
      script = ''
        rospkg --help
        touch $out
      '';
      nativeBuildInputs = [ rospkg ];
    };
  };

  meta = {
    description = "Library for retrieving information about ROS packages and stacks";
    homepage = "https://wiki.ros.org/rospkg";
    mainProgram = "rosversion";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
  };
}
