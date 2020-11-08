{ lib, buildPythonPackage, snap7, fetchFromGitHub, six, setuptools }:

buildPythonPackage rec {
  pname = "python-snap7";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "gijzelaerr";
    repo = "python-snap7";
    rev = "899a94c6eeca76fb9b18afd5056e5003646d7f94";
    sha256 = "169zd1nxq86nmi6132vxl1f6wxm9w3waihq2wn14kkmld1vkmvfd";
  };

  requiredPythonModules = [ setuptools six ];

  prePatch = ''
    substituteInPlace snap7/common.py \
      --replace "lib_location = None" "lib_location = '${snap7}/lib/libsnap7.so'"
  '';

  # Tests require root privileges to open privilaged ports
  # We cannot run them
  doCheck = false;

  pythonImportsCheck = [
    "snap7"
    "snap7.six"
    "snap7.util"
  ];

  meta = with lib; {
    description = "Python wrapper for the snap7 PLC communication library ";
    homepage = "https://github.com/gijzelaerr/python-snap7";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
