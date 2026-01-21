{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "cython-test-exception-raiser";
  version = "25.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twisted";
    repo = "cython-test-exception-raiser";
    tag = version;
    hash = "sha256-Od5LeytibiNZSDTI2KxK0SrDNvlQrKyL+5ea15Udi74=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "cython_test_exception_raiser" ];

  meta = {
    description = "Testing only. A cython simple extension which is used as helper for twisted/twisted Failure tests";
    homepage = "https://github.com/twisted/cython-test-exception-raiser";
    changelog = "https://github.com/twisted/cython-test-exception-raiser/blob/${src.tag}/CHANGELOG.rst";
    license = with lib.licenses; [
      publicDomain
      mit
    ];
    maintainers = [ ];
  };
}
