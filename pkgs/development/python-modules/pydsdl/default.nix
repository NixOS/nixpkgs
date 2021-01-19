{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder }:

 buildPythonPackage rec {
  pname = "pydsdl";
  version = "1.10.0";
  disabled = pythonOlder "3.6"; # only python>=3.6 is supported

  src = fetchFromGitHub {
    owner = "UAVCAN";
    repo = pname;
    rev = version;
    sha256 = "0ikwswd6q4nkfr7wnjf4llwh9alydj57ny5yys0yakaq457sy6q4";
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
