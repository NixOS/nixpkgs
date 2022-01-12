{ buildPythonPackage
, fetchFromGitHub
, isPy27
, lib

# pythonPackages
, astroid
, pytest
}:

buildPythonPackage rec {
  pname = "requirements-detector";
  version = "0.7";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "landscapeio";
    repo = pname;
    rev = version;
    sha256 = "sha256-DdPNqbTsL2+GUp8vppqUSa0mUVMxk73MCcpwo8u51tU=";
  };

  propagatedBuildInputs = [
    astroid
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description = "Python tool to find and list requirements of a Python project";
    homepage = "https://github.com/landscapeio/requirements-detector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
