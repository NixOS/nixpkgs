{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  mypy,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "3.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "charset_normalizer";
    tag = version;
    hash = "sha256-dOdJ4f98smCYdskp3BwtQG6aOyK+2a73+x580FKRWDk=";
  };

  postPatch = ''
    substituteInPlace _mypyc_hook/backend.py \
      --replace-fail "mypy>=1.4.1,<=1.20" "mypy"
  '';

  build-system = [
    setuptools
  ]
  ++ lib.optional (!isPyPy) mypy;

  env.CHARSET_NORMALIZER_USE_MYPYC = lib.optionalString (!isPyPy) "1";

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "charset_normalizer" ];

  passthru.tests = {
    inherit aiohttp requests;
  };

  meta = {
    description = "Python module for encoding and language detection";
    mainProgram = "normalizer";
    homepage = "https://charset-normalizer.readthedocs.io/";
    changelog = "https://github.com/jawah/charset_normalizer/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
