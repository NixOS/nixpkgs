{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bloom,
  catkin-pkg,
  empy,
  rosdep,
  rosdistro,
  setuptools,
  vcstools,
  pytestCheckHook,
  nix-update-script,
  testers,
}:

buildPythonPackage rec {
  pname = "bloom";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "bloom";
    rev = version;
    hash = "sha256-kTep9kjS1xNyTfuKEtMts2pVGMOXzUqDyMUwEpcbRXo=";
  };

  patches = [
    # TODO: Finish
    ./empy-v4.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    catkin-pkg
    empy
    rosdep
    rosdistro
    vcstools # Note: vcstools is abandoned. Once bloom is updated to remove this dependency, it should be removed from nixpkgs.
  ];

  nativeCheckInputs = [
    # I'm having trouble with pytest not finding rosdistro (?!)
    # pytestCheckHook
  ];

  pythonImportsCheck = [ "bloom" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      helpTest = testers.runCommand {
        name = "bloom";
        script = ''
          bloom-release --help
          touch $out
        '';
        nativeBuildInputs = [ rosdep ];
      };
      versionTest = testers.testVersion {
        package = bloom;
        command = "bloom-release --version";
        version = version;
      };
    };
  };

  meta = {
    description = "A release automation tool which makes releasing catkin (http://ros.org/wiki/catkin) packages easier";
    homepage = "https://github.com/ros-infrastructure/bloom";
    changelog = "https://github.com/ros-infrastructure/bloom/blob/master/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      pandapip1
      nim65s
    ];
  };
}
