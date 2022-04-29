{ lib, fetchPypi, buildPythonPackage
, six, udev, pytest, mock, hypothesis, docutils
}:

buildPythonPackage rec {
  pname = "pyudev";
  version = "0.23.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Mq41hbMgpRvCg+CgQAD9iiVZnttEVB4vUDT2r+5dFcw=";
  };

  postPatch = ''
    substituteInPlace src/pyudev/_ctypeslib/utils.py \
      --replace "find_library(name)" "'${lib.getLib udev}/lib/libudev.so'"
    '';

  checkInputs = [ pytest mock hypothesis docutils ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  # Bunch of failing tests
  # https://github.com/pyudev/pyudev/issues/187
  doCheck = false;

  meta = {
    homepage = "https://pyudev.readthedocs.org/";
    description = "Pure Python libudev binding";
    license = lib.licenses.lgpl21Plus;
  };
}
