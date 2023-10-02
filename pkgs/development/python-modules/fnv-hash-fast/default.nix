{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, poetry-core
, setuptools
, wheel
, fnvhash
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fnv-hash-fast";
  version = "0.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "fnv-hash-fast";
    rev = "v${version}";
    hash = "sha256-vKv3Hfla+U1teYVB+w8ONj0Ur996noanbg6aaJ6S6+I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=fnv_hash_fast --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    fnvhash
  ];

  pythonImportsCheck = [
    "fnv_hash_fast"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A fast version of fnv1a";
    homepage = "https://github.com/bdraco/fnv-hash-fast";
    changelog = "https://github.com/bdraco/fnv-hash-fast/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
