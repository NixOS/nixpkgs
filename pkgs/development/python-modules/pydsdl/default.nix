{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder }:

 buildPythonPackage rec {
  pname = "pydsdl";
  version = "1.4.2";
  disabled = pythonOlder "3.5"; # only python>=3.5 is supported

  src = fetchFromGitHub {
    owner = "UAVCAN";
    repo = pname;
    rev = version;
    sha256 = "03kbpzdrjzj5vpgz5rhc110pm1axdn3ynv88b42zq6iyab4k8k1x";
  };

  propagatedBuildInputs = [
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  # repo doesn't contain tests, ensure imports aren't broken
  pythonImportsCheck = [
    "pydsdl"
  ];

  meta = with lib; {
    description = "A UAVCAN DSDL compiler frontend implemented in Python";
    longDescription = ''
      It supports all DSDL features defined in the UAVCAN specification.
    '';
    homepage = "https://uavcan.org";
    maintainers = with maintainers; [ wucke13 ];
    license = licenses.mit;
  };
}
