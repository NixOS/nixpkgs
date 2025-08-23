{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,

  setuptools,

  click,
  snap7,
}:

buildPythonPackage rec {
  pname = "python-snap7";
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "gijzelaerr";
    repo = "python-snap7";
    tag = version;
    hash = "sha256-mcdzgR0z2P5inK9Q+ZQhP5H8vZSaPbRCSEnt+wzG+ro=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  postInstall = ''
    ln -s ${snap7}/lib $out/${python.sitePackages}/snap7/lib
  '';

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
