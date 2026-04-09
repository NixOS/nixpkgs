{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mypy-extensions,
  python,
  pytest,
}:

buildPythonPackage rec {
  pname = "librt";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = "librt";
    tag = "v${version}";
    hash = "sha256-RZGaOq8hmkwekCs1fKshDrx3vmHdJl/wI3IO9ZLH5rc=";
  };

  # https://github.com/mypyc/librt/blob/v0.9.0/.github/workflows/buildwheels.yml#L90-L93
  postPatch = ''
    cp -rv lib-rt/* .
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    mypy-extensions
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} smoke_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "librt"
    "librt.internal"
  ];

  meta = {
    description = "Mypyc runtime library";
    homepage = "https://github.com/mypyc/librt";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
