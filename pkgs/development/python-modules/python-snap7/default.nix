{
  lib,
  buildPythonPackage,
  snap7,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-snap7";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gijzelaerr";
    repo = "python-snap7";
    rev = "refs/tags/${version}";
    hash = "sha256-CqLG5/U2k7WdZL5LfcFAnV1Q8HcIU7l36gi51lgB39s=";
  };

  prePatch = ''
    substituteInPlace snap7/common.py \
      --replace "lib_location = None" "lib_location = '${snap7}/lib/libsnap7.so'"
  '';

  build-system = [ setuptools ];

  # Tests require root privileges to open privileged ports
  doCheck = false;

  pythonImportsCheck = [
    "snap7"
    "snap7.util"
  ];

  meta = with lib; {
    description = "Python wrapper for the snap7 PLC communication library";
    mainProgram = "snap7-server";
    homepage = "https://github.com/gijzelaerr/python-snap7";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
