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
  version = "1.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "twisted";
    repo = "cython-test-exception-raiser";
    rev = "v${version}";
    hash = "sha256-fwMq0pOrFUJnPndH/a6ghoo6mlcVSxtsWazqE9mCx3M=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "cython_test_exception_raiser" ];

  meta = with lib; {
    description = "Testing only. A cython simple extension which is used as helper for twisted/twisted Failure tests";
    homepage = "https://github.com/twisted/cython-test-exception-raiser";
    changelog = "https://github.com/twisted/cython-test-exception-raiser/blob/${src.rev}/CHANGELOG.rst";
    license = with licenses; [
      publicDomain
      mit
    ];
    maintainers = with maintainers; [ ];
  };
}
