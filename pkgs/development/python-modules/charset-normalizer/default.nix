{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mypy,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "3.4.1";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Ousret";
    repo = "charset_normalizer";
    tag = version;
    hash = "sha256-z6XUXfNJ4+2Gq2O13MgF1D3j/bVBjgAG2wCWLaNgADE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "mypy>=1.4.1,<=1.14.0" mypy
  '';

  build-system = [
    mypy
    setuptools
    setuptools-scm
  ];

  env.CHARSET_NORMALIZER_USE_MYPYC = "1";

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "charset_normalizer" ];

  passthru.tests = {
    inherit aiohttp requests;
  };

  meta = with lib; {
    description = "Python module for encoding and language detection";
    mainProgram = "normalizer";
    homepage = "https://charset-normalizer.readthedocs.io/";
    changelog = "https://github.com/Ousret/charset_normalizer/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
