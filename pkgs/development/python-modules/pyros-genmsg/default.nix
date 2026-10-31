{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  empy,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pyros-genmsg";
  version = "0.5.8";
  pyproject = true;

  # Only ever released to PyPI at this version; the GitHub tags of the real
  # upstream (ros/genmsg) require catkin_pkg (a much larger ROS buildtool
  # dependency chain) just to run its setup.py, whereas this PyPI sdist's
  # setup.py reads the same upstream package.xml directly via stdlib xml,
  # with no extra build dependency.
  src = fetchPypi {
    pname = "pyros_genmsg";
    inherit version;
    hash = "sha256-PBywfZxA+eYIcph+7Jg6rFvbWSDqd5gDA/scRsMI9Hg=";
  };

  build-system = [ setuptools ];

  dependencies = [ empy ];

  pythonImportsCheck = [ "genmsg" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Standalone Python library for generating ROS message and service data structures";
    homepage = "https://github.com/ros/genmsg";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
