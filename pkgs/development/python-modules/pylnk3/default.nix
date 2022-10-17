{ lib
, buildPythonPackage
, fetchPypi
, pytest
, twine
, invoke
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylnk3";
  version = "0.4.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "pylnk3";
    sha256 = "sha256-yu4BNvYai3iBVNyOfAOsLd5XrcFw8cR4arRyFJHKbpk=";
  };

   propagatedBuildInputs = [
     pytest
     invoke
  ];
  # There are no tests in pylnk3.
  doCheck = false;

  pythonImportsCheck = [
    "pylnk3"
  ];

  meta = with lib; {
    description = "Python library for reading and writing Windows shortcut files (.lnk)";
    homepage = "https://github.com/strayge/pylnk";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ fedx-sudo ];
  };
}
