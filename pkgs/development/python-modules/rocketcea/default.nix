{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  meson-python,
  setuptools,
  wheel,
  numpy,
  scipy,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "rocketcea";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sonofeft";
    repo = "RocketCEA";
    tag = "v${version}";
    hash = "sha256-nklc6aofTeOT8LJ//c8R/Ch9tJueJ+yHKLVsMukKmnY=";
  };

  nativeBuildInputs = [
    gfortran
    meson
    ninja
  ];

  build-system = [
    meson-python
    setuptools
    wheel
  ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  pythonImportsCheck = [ "rocketcea" ];

  meta = {
    description = "RocketCEA: Wraps NASA CEA for rocket propulsion analysis";
    homepage = "https://github.com/sonofeft/RocketCEA";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ duranmartin ];
  };
}
