{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  catkin-tools,
  setuptools,
  osrf-pycommon,
  pyyaml,
  catkin-pkg,
  mock,
  pytestCheckHook,
  nix-update-script,
  testers,
}:

buildPythonPackage rec {
  pname = "catkin-tools";
  version = "0.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "catkin";
    repo = "catkin_tools";
    tag = version;
    hash = "sha256-8OQbN58zaCbxg/TEGJGwbBsfmSfpN+jjT7zf1eG2Dnc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    osrf-pycommon
    pyyaml
    catkin-pkg
  ];

  checkInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "catkin_tools" ];

  disabledTestPaths = [
    # Has duplicate basenames which causes issues
    "tests/system"
    # Can't find flake8 even when installed. Also not necessary to test functionality.
    "tests/test_code_format.py"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      versionTest = testers.testVersion {
        package = catkin-tools;
        command = "HOME=$(mktemp -d) catkin --version";
        version = version;
      };
      helpTest = testers.runCommand {
        name = "catkin-tools";
        script = ''
          HOME=$(mktemp -d) catkin --help
          touch $out
        '';
        nativeBuildInputs = [ catkin-tools ];
      };
    };
  };

  meta = {
    description = "Command line tools for working with catkin";
    homepage = "https://catkin-tools.readthedocs.io/";
    mainProgram = "catkin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
  };
}
