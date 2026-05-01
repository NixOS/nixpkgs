{
  lib,
  authlib,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  poetry-core,
  requests,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvicare";
  version = "2.59.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openviess";
    repo = "PyViCare";
    tag = finalAttrs.version;
    hash = "sha256-dy6VFVisQXWB46pdltP2Ww/WyAyQ1igLn8LiSGHPKa8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.1.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    authlib
    deprecated
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "PyViCare" ];

  meta = {
    description = "Python Library to access Viessmann ViCare API";
    homepage = "https://github.com/somm15/PyViCare";
    changelog = "https://github.com/openviess/PyViCare/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
