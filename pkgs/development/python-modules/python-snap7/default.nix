{ lib, buildPythonPackage, snap7, fetchFromGitHub, six, setuptools }:

buildPythonPackage rec {
  pname = "python-snap7";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "gijzelaerr";
    repo = "python-snap7";
    rev = version;
    sha256 = "18z13wb2q5q3msp9w3wddg1byp7picczw4ng8w1ccj4npidxsqv8";
  };

  propagatedBuildInputs = [ setuptools six ];

  prePatch = ''
    substituteInPlace snap7/common.py \
      --replace "lib_location = None" "lib_location = '${snap7}/lib/libsnap7.so'"
  '';

  # Tests require root privileges to open privilaged ports
  # We cannot run them
  doCheck = false;

  pythonImportsCheck = [
    "snap7"
    "snap7.util"
  ];

  meta = with lib; {
    description = "Python wrapper for the snap7 PLC communication library ";
    homepage = "https://github.com/gijzelaerr/python-snap7";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
