{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython_3_2,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "cython-test-exception-raiser";
  version = "26.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twisted";
    repo = "cython-test-exception-raiser";
    tag = finalAttrs.version;
    hash = "sha256-TYgb8ZtEcXsVYgspK336H3WaZAYivTMcpvLAY/CEkkA=";
  };

  nativeBuildInputs = [
    cython_3_2
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "cython_test_exception_raiser" ];

  meta = {
    description = "Testing only. A cython simple extension which is used as helper for twisted/twisted Failure tests";
    homepage = "https://github.com/twisted/cython-test-exception-raiser";
    changelog = "https://github.com/twisted/cython-test-exception-raiser/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = with lib.licenses; [
      publicDomain
      mit
    ];
    maintainers = [ ];
  };
})
