{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, cattrs
, attrs
, nox
, pytest
, pyhamcrest
, jsonschema
}:

buildPythonPackage rec {
  pname = "lsprotocol";
  version = "2022.0.0a9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = version;
    hash = "sha256-6XecPKuBhwtkmZrGozzO+VEryI5wwy9hlvWE1oV6ajk=";
  };

  nativeBuildInputs = [
    flit-core
    nox
  ];

  propagatedBuildInputs = [
    cattrs
    attrs
  ];

  checkInputs = [
    pytest
    pyhamcrest
    jsonschema
  ];

  checkPhase = ''
    runHook preCheck

    sed -i "/^    _install_requirements/d" noxfile.py
    nox --session tests

    runHook postCheck
  '';

  pythonImportsCheck = [ "lsprotocol" ];

  meta = with lib; {
    homepage = "https://github.com/microsoft/lsprotocol";
    description = "Python implementation of the Language Server Protocol.";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
