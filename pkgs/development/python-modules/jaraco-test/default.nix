{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  jaraco-functools,
  jaraco-context,
  jaraco-collections,
  pytest8_3CheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jaraco-test";
  version = "5.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.test";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c8N4Q4zNZolhJ9osBOaorWXNINnuA5PV0y5DHZISHaY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"coherent.licensed",' ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    jaraco-functools
    jaraco-context
    jaraco-collections
  ];

  nativeCheckInputs = [ pytest8_3CheckHook ];

  pythonImportsCheck = [ "jaraco.test" ];

  meta = {
    description = "Testing support by jaraco";
    homepage = "https://github.com/jaraco/jaraco.test";
    changelog = "https://github.com/jaraco/jaraco.test/blob/${finalAttrs.src.tag}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
