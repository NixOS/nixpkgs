{
  buildPythonPackage,
  catkin-pkg,
  fetchFromGitHub,
  lib,
  nix-update-script,
  pytestCheckHook,
  pyyaml,
  rospkg,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rosdistro";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros-infrastructure";
    repo = "${pname}";
    tag = "${version}";
    hash = "sha256-ETsQzWsoGrThxNI/L3pWEzkhmrh+jpy/KIkojPMTkLw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    catkin-pkg
    pyyaml
    rospkg
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "test/test_manifest_providers.py" # Requires internet access
    "test/test_index.py" # Fails on darwin
  ];

  pythonImportsCheck = [ "${pname}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ros-infrastructure/${pname}/blob/${version}/CHANGELOG.rst";
    description = "Tools to work with catkinized rosdistro files";
    homepage = "https://github.com/ros-infrastructure/${pname}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ amronos ];
    platforms = lib.platforms.all;
  };
}
