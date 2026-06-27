{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rtimulib2";

  # Version comes from RTIMULibVersion.txt; the wheel reports the same.
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "seandepagnier";
    repo = "RTIMULib2";
    rev = "810272f36db3b8b8486ac1f495b6d6222edb480c";
    hash = "sha256-AZ3q2MEa5orJm3GCpPGfvzVFKV88Uwux4wul8QXttEA=";
  };

  # setup.py reads ../../RTIMULibVersion.txt and ../../RTIMULib relative to
  # this dir; both resolve into the unpacked tree.
  sourceRoot = "${src.name}/Linux/python";

  pyproject = true;
  build-system = [ setuptools ];

  pythonImportsCheck = [ "RTIMU" ];

  meta = {
    description = "richards-tech IMU sensor fusion library, Python binding (pypilot fork)";
    homepage = "https://github.com/seandepagnier/RTIMULib2";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.darkone ];
    platforms = lib.platforms.linux;
  };
}
