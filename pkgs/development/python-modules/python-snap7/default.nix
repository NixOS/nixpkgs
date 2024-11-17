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
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gijzelaerr";
    repo = "python-snap7";
    rev = "refs/tags/${version}";
    hash = "sha256-mcdzgR0z2P5inK9Q+ZQhP5H8vZSaPbRCSEnt+wzG+ro=";
  };

  prePatch = ''
    substituteInPlace snap7/common.py \
      --replace-fail "lib_location = None" "lib_location = '${snap7}/lib/libsnap7.so'"
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
    homepage = "https://github.com/gijzelaerr/python-snap7";
    changelog = "https://github.com/gijzelaerr/python-snap7/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
    mainProgram = "snap7-server";
  };
}
