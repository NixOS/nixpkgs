{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mypy-extensions,
  python,
}:

buildPythonPackage rec {
  pname = "librt";
  version = "0.7.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mypyc";
    repo = "librt";
    tag = "v${version}";
    hash = "sha256-FlLilZQMsXAYfreBAfYoutCEww8IVoU7jjxvvJr8pTk=";
  };

  # https://github.com/mypyc/librt/blob/v0.7.8/.github/workflows/buildwheels.yml#L90-L93
  postPatch = ''
    cp -rv lib-rt/* .
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    mypy-extensions
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
