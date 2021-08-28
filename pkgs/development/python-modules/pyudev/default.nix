{ lib, fetchPypi, buildPythonPackage
, six, udev, pytest, mock, hypothesis, docutils
}:

buildPythonPackage rec {
  pname = "pyudev";
  version = "0.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xmj6l08iih2js9skjqpv4w7y0dhxyg91zmrs6v5aa65gbmipfv9";
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
