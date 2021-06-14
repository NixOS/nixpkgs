{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder }:

 buildPythonPackage rec {
  pname = "pydsdl";
  version = "1.9.4";
  disabled = pythonOlder "3.5"; # only python>=3.5 is supported

  src = fetchFromGitHub {
    owner = "UAVCAN";
    repo = pname;
    rev = version;
    sha256 = "1hmmc4sg6dckbx2ghcjpi74yprapa6lkxxzy0h446mvyngp0kwfv";
  };

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  # repo doesn't contain tests
  doCheck = false;

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
