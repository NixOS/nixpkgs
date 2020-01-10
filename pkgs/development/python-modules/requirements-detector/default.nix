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
  version = "0.6";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "landscapeio";
    repo = pname;
    rev = version;
    sha256 = "1sfmm7daz0kpdx6pynsvi6qlfhrzxx783l1wb69c8dfzya4xssym";
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
