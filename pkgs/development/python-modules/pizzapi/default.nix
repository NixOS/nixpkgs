{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  xmltodict,
  pyhamcrest,
  mock,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "pizzapi";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggrammar";
    repo = "pizzapi";
    rev = "2a67ceb0f6df285988f1a2d7b678bbd2526c26a4";
    hash = "sha256-oBwNNsnRhm/kv8DxNrAKkeGv2RZA+RMdYRgByy3qmsU=";
  };

  postPatch = ''
    # Remove pytest-runner from setup_requires
    substituteInPlace setup.py \
      --replace-fail 'setup_requires=["pytest-runner"],' 'setup_requires=[],'
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    xmltodict
    pyhamcrest
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pizzapi" ];

  meta = {
    description = "Python wrapper for the Dominos Pizza API";
    homepage = "https://github.com/ggrammar/pizzapi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
