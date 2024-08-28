{
  lib,
  attrs,
  buildPythonPackage,
  cattrs,
  fetchFromGitHub,
  flit-core,
  importlib-resources,
  jsonschema,
  nox,
  pyhamcrest,
  pytest,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "lsprotocol";
  version = "2023.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "lsprotocol";
    rev = "refs/tags/${version}";
    hash = "sha256-PHjLKazMaT6W4Lve1xNxm6hEwqE3Lr2m5L7Q03fqb68=";
  };

  nativeBuildInputs = [
    flit-core
    nox
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
  ];

  nativeCheckInputs = [ pytest ];

  checkInputs = [
    importlib-resources
    jsonschema
    pyhamcrest
  ];

  preBuild = ''
    cd packages/python
  '';

  preCheck = ''
    cd ../../
  '';

  checkPhase = ''
    runHook preCheck

    sed -i "/^    _install_requirements/d" noxfile.py
    nox --session tests

    runHook postCheck
  '';

  pythonImportsCheck = [ "lsprotocol" ];

  meta = with lib; {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/microsoft/lsprotocol";
    changelog = "https://github.com/microsoft/lsprotocol/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      doronbehar
      fab
    ];
  };
}
