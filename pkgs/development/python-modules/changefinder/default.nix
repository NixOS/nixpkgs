{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, numpy
, scipy
, statsmodels
}:

buildPythonPackage {
  pname = "changefinder";
  version = "unstable-2024-03-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shunsukeaihara";
    repo = "changefinder";
    rev = "58c8c32f127b9e46f9823f36221f194bdb6f3f8b";
    hash = "sha256-1If0gIsMU8673fKSSHVMvDgR1UnYgM/4HiyvZJ9T6VM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    statsmodels
  ];

  pythonImportsCheck = [ "changefinder" ];

  meta = with lib; {
    description = "Online Change-Point Detection library based on ChangeFinder algorithm";
    homepage = "https://github.com/shunsukeaihara/changefinder";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
