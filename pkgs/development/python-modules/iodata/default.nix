{ buildPythonPackage, lib, fetchFromGitHub, numpy, scipy, attrs, cython, nose }:

buildPythonPackage rec {
  pname = "iodata";
  version = "0.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "theochem";
    repo = pname;
    rev = version;
    hash = "sha256-Qn2xWFxdS12K92DhdHVzYrBjPRV+vYo7Cs27vkeCaxM=";
  };

  leaveDotGit = true;

  nativeBuildInputs = [ cython nose ];
  propagatedBuildInputs = [ numpy scipy attrs ];

  pythonImportsCheck = [ "iodata" "iodata.overlap_accel" ];
  doCheck = false; # Requires roberto or nose and a lenghtly setup to find the cython modules

  meta = with lib; {
    description = "Python library for reading, writing, and converting computational chemistry file formats and generating input files";
    homepage = "https://github.com/theochem/iodata";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
