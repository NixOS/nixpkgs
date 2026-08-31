{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, pandas
, rpyc
, numba
, pyft232
, pyvisa
, pyserial
, pyusb
, pyqt5
, pyqtgraph
}:

buildPythonPackage rec {
  pname = "pylablib";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "AlexShkarin";
    repo = "pyLabLib";
    rev = "v${version}";
    hash = "sha256-4yN/mUka1VAdc5cR4Sd0UY/mmVMQ4CeRg5jnKDfzFPk=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pandas
    rpyc
    numba
    pyft232
    pyvisa
    pyserial
    pyusb
    pyqt5
    pyqtgraph
  ];

  doCheck = false;

  meta = with lib; {
    description = "Python package for device control and experiment automation";
    homepage = "https://github.com/AlexShkarin/pyLabLib";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fsagbuya ];
  };
}
