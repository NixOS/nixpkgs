{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  gitMinimal,
  eradicate,
  mccabe,
  mypy,
  pycodestyle,
  pydocstyle,
  pyflakes,
  vulture,
  setuptools_80,
  pylint,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylama";
  version = "8.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klen";
    repo = "pylama";
    tag = finalAttrs.version;
    hash = "sha256-WOGtZ412tX3YH42JCd5HIngunluwtMmQrOSUZp23LPU=";
  };

  patches = [
    (replaceVars ./paths.patch {
      git = lib.getExe gitMinimal;
    })
    ./pytest-9.1-compat.patch
    ./setuptools-82-compat.patch
  ];

  build-system = [ setuptools_80 ];

  dependencies = [
    eradicate
    mccabe
    mypy
    pycodestyle
    pydocstyle
    pyflakes
    vulture
  ];

  # escape infinite recursion pylint -> isort -> pylama
  doCheck = false;

  nativeCheckInputs = [
    pylint
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  disabledTests = [
    "test_quotes" # FIXME package pylama-quotes
    "test_radon" # FIXME package radon
  ];

  pythonImportsCheck = [ "pylama.main" ];

  passthru.tests = {
    check = finalAttrs.finalPackage.overrideAttrs (_: {
      doInstallCheck = true;
    });
  };

  meta = {
    description = "Code audit tool for python";
    mainProgram = "pylama";
    homepage = "https://github.com/klen/pylama";
    changelog = "https://github.com/klen/pylama/blob/${finalAttrs.src.tag}/Changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
