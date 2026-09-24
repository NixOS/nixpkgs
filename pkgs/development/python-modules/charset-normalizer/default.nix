{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  ast-serialize,
  mypy,
  pytestCheckHook,
  requests,
  setuptools,
  withMypyc ? !isPyPy && !stdenv.hostPlatform.isStatic,
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "3.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "charset_normalizer";
    tag = version;
    hash = "sha256-YOskF90ach/qEwnMeYDEEO2H4DOoz/LZApXDRU9mvnM=";
  };

  postPatch = ''
    substituteInPlace _mypyc_hook/backend.py \
      --replace-fail "mypy>=1.4.1,<2.2" "mypy"
  '';

  build-system = [
    setuptools
  ]
  ++ lib.optionals withMypyc [
    ast-serialize
    mypy
  ];

  env.CHARSET_NORMALIZER_USE_MYPYC = lib.optionalString withMypyc "1";

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
