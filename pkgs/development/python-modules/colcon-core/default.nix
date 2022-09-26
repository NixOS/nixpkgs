{ lib, fetchgit, buildPythonPackage, coloredlogs, empy, pytest, pytest-cov, pytest-repeat, pytest-rerunfailures, distlib, mock, flake8, pydocstyle }:

buildPythonPackage rec {
  pname = "colcon-core";
  version = "0.6.1";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-core.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "/T4wm/GAscYNoCeDWM/Fg1cznzk0bb0c2saIA4HTIbQ=";
  };
  propagatedBuildInputs = [ coloredlogs empy distlib pytest pytest-repeat pytest-cov pytest-rerunfailures pydocstyle ];

  postPatch = ''
    # Remove test that relies on esoteric spell checker
    # that isn't important for testing code functionality
    rm test/test_spell_check.py;
  '';

  checkInputs = [ pytest mock flake8 ];
  checkPhase = "pytest test";
  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-core";
    description = "Command line tool to build sets of software packages.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}
