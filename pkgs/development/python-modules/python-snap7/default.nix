{ lib, buildPythonPackage, snap7, fetchFromGitHub, six, setuptools }:

buildPythonPackage rec {
  pname = "python-snap7";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "gijzelaerr";
    repo = "python-snap7";
    rev = version;
    sha256 = "103drdwf4v3yqvd7sscxx154mmmshb6x19v9yqmkj2lj76m0619s";
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
