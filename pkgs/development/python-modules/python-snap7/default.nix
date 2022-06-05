{ lib
, buildPythonPackage
, snap7
, fetchFromGitHub
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-snap7";
  version = "1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gijzelaerr";
    repo = "python-snap7";
    rev = "refs/tags/${version}";
    hash = "sha256-xkkJE3wTqS6spwEmQ+HBY1Szao1VFoqmQ041vnAYuqQ=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  prePatch = ''
    substituteInPlace snap7/common.py \
      --replace "lib_location = None" "lib_location = '${snap7}/lib/libsnap7.so'"
  '';

  # Tests require root privileges to open privilaged ports
  doCheck = false;

  pythonImportsCheck = [
    "snap7"
    "snap7.util"
  ];

  meta = with lib; {
    description = "Python wrapper for the snap7 PLC communication library";
    homepage = "https://github.com/gijzelaerr/python-snap7";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
